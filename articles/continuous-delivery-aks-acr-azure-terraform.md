title: "Continuous Delivery to AKS with a Service Principal, Securely"
slug: continuous-delivery-aks-acr-azure-terraform
publish_date: "2021-07-16"

open_graph_meta:
  title: "Continuous Delivery to AKS with a Service Principal, Securely"
  description: >
    Deploying to Azure Kubernetes Service without opening security holes can be
    daunting, but Terraform can help.

---

Azure has some great features, and leads the industry in a few different ways,
especially around region support and disaster recovery. But, as with
everything, all these great features comes tradeoffs. Azure Active Directory
(AAD) is one of those tradeoffs.

Our story begins with configuring continuous delivery. It was all going
smoothly until we had to authenticate with Azure Container Registry (ACR) and
Azure Kubernetes Service (AKS). What, in AWS, would have just been an IAM role,
in Azure is a full "Enterprise Application" within AAD.

This "Enterprise Application" is a full-blown (private) Azure Marketplace
OAuth2 integration. You can take this thing as far as building an entire
product on top of Azure. However, in our case, we just want to push some Docker
containers from CI.

To make things worse, finding examples or documentation on building restrictive
application roles can be often fruitless. Almost every blog post, documentation
page, or StackOverflow answer just had the bare example using the Azure CLI:

```
$ az ad sp create-for-rbac --subscription <id>
```

This command will automatically create an Enterprise Application and a Service
Principal behind the scenes, and then spit out the credentials for it right
away. Easy, right?

Well, by default it will be scoped to the entire subscription, which means it
will have full, unfettered access to every resource in your subscription. It's
basically like deploying a web app using `root`. If these credentials leak, it
could bring down your entire stack, or possibly even your entire company.

You can lock it down a bit using `--scope`, to scope the access down to even
just a single resource. This is great, but not quite far enough. It's
significantly better than access to the entire account, but unfettered access
to a production Kubernetes cluster is also rather undesirable.

We need to go deeper.

## Terraforming AAD

Luckily, there is an official `hashicorp/azuread` provider for Terraform! This,
along with some help from the usual `hashicorp/azurerm` provider, will allow us
to entirely automate, audit, and track changes to our AAD service principals.

The first step is to get the Application and Service Principal created. That is
fairly straightforward:

```hcl
resource "azuread_application" "appcd" {
  display_name = "MyAppCD${terraform.workspace}"
}

resource "azuread_service_principal" "appcd" {
  application_id = azuread_application.appcd.application_id
}

resource "azuread_application_password" "appcd" {
  application_object_id = azuread_application.appcd.object_id
  end_date_relative     = "8766h" # 1.00068 years
}
```

Nothing should be too surprising here. The "application password" is equivalent
to the "client secret". It will be generated for us, and we'll use an `output`
later to get access to its value.

The fun begins when we start to define some custom roles. This is why we're
here in the first place: we want to apply only the most minimal set of
permissions to allow CI to roll out containers and update our Kubernetes
deployments.

Let's start with Azure Container Registry:

```hcl
# Similar to the built-in "AcrPush", but also allows queuing remote builds.
resource "azurerm_role_definition" "acrBuild" {
  name  = "MyAppACRBuild${terraform.workspace}"
  scope = azurerm_resource_group.main.id

  permissions {
    actions = [
      "Microsoft.ContainerRegistry/registries/read",
      "Microsoft.ContainerRegistry/registries/pull/read",
      "Microsoft.ContainerRegistry/registries/push/write",
      "Microsoft.ContainerRegistry/registries/scheduleRun/action",
      "Microsoft.ContainerRegistry/registries/runs/*",
      "Microsoft.ContainerRegistry/registries/listBuildSourceUploadUrl/action",
    ]

    not_actions = []
  }
}
```

We rely quite heavily on ACR's "runs", which are remote-builds of containers
within ACR's infrastructure. This is much safer than building them on CI as it
can be done entirely within Azure instead of on some shared CI platform. It
also means we don't have to worry about pushing images around or dealing with
registry credentials in CI.

This role is a bit "loose" in that it also allows traditional push/pull access,
but this should be fine, as it's not opening up any more capability. If we need
to, for whatever reason, switch to local container builds in CI, I don't want
to have to bother with changing the role just for that.

Once we have our containers, we need to access AKS. This is where the custom
roles really shine. Before, we would have had to have given full cluster access
just so CI could update some image tags. Now, we can lock things down rather
tightly:

```hcl
resource "azurerm_role_definition" "aksDeploy" {
  name  = "MyAppAKSDeploy${terraform.workspace}"
  scope = azurerm_resource_group.main.id

  permissions {
    actions = [
      "Microsoft.ContainerService/managedClusters/read",
      "Microsoft.ContainerService/managedClusters/accessProfiles/listCredential/action",
    ]

    data_actions = [
      "Microsoft.ContainerService/managedClusters/apps/deployments/read",
      "Microsoft.ContainerService/managedClusters/apps/deployments/write",
    ]

    not_actions = []
  }
}
```

This policy allows our Service Principal to **only** get their credentials, and
read and write to deployments. They can't delete anything, can't create new
resources, only updates and only to deployments.

This is still "open" in that we aren't specifying _which deployments_ it should
update, but this is still much better than anything else we've seen so far.
There is likely a way for us to take this further, but since our Kubernetes
clusters are generally single-tenant and single-environment, it's not much of a
concern.

Which leads us to the assignments. The Role Assignments are where we can lock
things down even further by only scoping these permissions down to specific
resources.

```hcl
resource "azurerm_role_assignment" "appcdAKS" {
  scope              = azurerm_kubernetes_cluster.main.id
  role_definition_id = azurerm_role_definition.aksDeploy.role_definition_resource_id
  principal_id       = azuread_service_principal.appcd.id
}

resource "azurerm_role_assignment" "appcdACR" {
  scope              = azurerm_container_registry.main.id
  role_definition_id = azurerm_role_definition.acrBuild.role_definition_resource_id
  principal_id       = azuread_service_principal.appcd.id
}
```

With this, we should have everything we need. We can then assemble an output
with the equivalent JSON blob that the `az` command line spits out:

```hcl
data "azurerm_subscription" "primary" { }

output "appcd_service_principal" {
  value = <<EOF
{
  "clientId": "${azuread_application.appcd.application_id}",
  "clientSecret": "${azuread_application_password.appcd.value}",
  "subscriptionId": "${data.azurerm_subscription.primary.subscription_id}",
  "tenantId": "${data.azurerm_subscription.primary.tenant_id}",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
  EOF
}
```

This JSON blob will be output at the end of `terraform apply` with all the
right values populated. Take it, put it in a secret, and then you can use it to
authenticate with Azure from CI and deploy what you need.

## Where to go from here

Azure AD is a complex and often unforgiving beast. But given a lot of time and
learning, it can be honed into a very powerful tool that makes you and your
infrastructure safer.

Getting this far took many hours of trial-and-error and research. It was not a
particularly pleasant process. However, the result was worth it, and I'm pretty
happy with how it turned out.

Figuring out which actions you need is by far the worst part of this process.
Perhaps the best resource is [this enormous list of every `action` in Azure](https://docs.microsoft.com/en-us/azure/role-based-access-control/resource-provider-operations).
It's a lot to search through, but you can usually figure out which ones you
want.

And, if it comes down to it, the errors returned by Azure when you are missing
a permission often include the exact action required so you can just
copy-and-paste that into your role and try again.

Hopefully you were able to take something from this article, and here's to more
secure deployments.
