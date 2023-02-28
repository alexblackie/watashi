title: "Stateless Nextcloud on Kubernetes"
slug: nextcloud-on-k8s
publish_date: "2020-07-17"
updated_date: "2021-08-30"

cover:
  url: /images/articles/nextcloud-on-k8s/420scaleit.jpg
  alt: "Nextcloud and Kubernetes logos on a blue background."
  width: 1739
  height: 594

openGraphTitle: "Stateless Nextcloud on Kubernetes"
openGraphDescription: "I am a heavy user of Nextcloud, but scaling it can be a challenge. Here is how I managed to get it to a place I can trust."
openGraphImageUrl: /images/articles/nextcloud-on-k8s/420scaleit.jpg
---
<p>
	<big>
		Since early 2018, I have used <a href="https://nextcloud.com">Nextcloud</a>
		in a production capacity, providing domestic, privacy-respecting
		cloud file storage for myself and my family. Over the years, I
		have spent a considerable amount of time finding a way to run it
		safely, ensuring that decades of documents, photos, and other
		critical data do not go missing.
	</big>
</p>

<div class="note">
	<div class="note--body">
		<strong>Update 2021-08:</strong> Since writing thist post I have moved
		back to a more "traditional" hosting method involving physical hardware
		in a datacentre and lots of SSDs. I enjoyed the challenge of making
		Nextcloud "cloud-native" but ultimately I think it's more trouble than
		it's worth. I am very happy with the simplicity of just running it on
		normal bare hardware and don't intend on going back to a
		Kubernetes-based deployment any time soon.
	</div>
</div>

<p>
	In recent years, Kubernetes has powered my production infrastructure, and
	so finding a way to force Nextcloud into the stateless container model has
	been a goal of mine for a while, as that would provide the desired
	reliability and horizontal scaling capabilities.
</p>

<p>
	Like many legacy-ridden PHP applications, Nextcloud is heavily filesystem
	driven, and demands a mutable filesystem to operate in any capacity. This
	filesystem dependence was a large problem in the migration to Kubernetes,
	but with a bit of late-night research, a few experiments, and a couple
	shell scripts, I am finally content with the redundancy and elasticity of
	my current solution.
</p>

<p>
	As of now, I have achieved all the goals I set as a baseline for me to
	trust Nextcloud:

	<ul>
		<li>
			<mark>All user content is stored in object storage</mark>,
			removing "storage limit anxiety" and offering unmatched data
			resiliency compared to a single disk or an array of physical
			drives.
		</li>
		<li>
			<mark>Pods can be scaled</mark> with haste to meet demand during
			heavy usage periods, and utilise existing autoscaling concepts like
			HPA's.
		</li>
		<li>
			<mark>Containers are stateless</mark>, and do not share a
			filesystem with each other or the user data, meaning rollbacks and
			scaling carry minimal risk.
		</li>
	</ul>
</p>

<p>
	Over the past year I've slowly worked toward these goals, introducing one
	at a time to ensure stability.
</p>

<h2>Stage One: Object Storage</h2>

<p>
	Before even considering moving to Kubernetes, I had to first get object
	storage working. I had previously experimented with the "External Storages
	[sic]" support, which seemed to work well but wasn't as transparent as I
	wanted.
</p>

<p>
	Luckily, there is
	<a href="https://docs.nextcloud.com/server/15/admin_manual/configuration_files/primary_storage.html">official documentation</a>
	outlining how to set this up. It's quite simple, and just requires a few
	lines in <code>config.php</code>:
</p>

<div class="code">
	<div class="code-title">config.php</div>

```php
<?php
[...]
  'objectstore' => array (
    'class' => 'OC\\Files\\ObjectStore\\S3',
    'arguments' => array (
      'bucket' => 'my-nextcloud-data-bucket',
      'autocreate' => false,
      'use_path_style' => true,
      'port' => 9000,
      'key' => 'AKIAxxx',
      'secret' => 'asd+fx/xxxx=',
      'hostname' => 'nxc-minio',
      'use_ssl' => false,
      'region' => 'ca-central-1',
    ),
  ),
[...]
```
</div>

<p>
	Astute readers may notice I am not pointing to S3 directly, but more on
	that later.
</p>

<p>
	The only thing I was unsure about was migrating existing data to a new
	primary backend, which I'm still not sure is possible. Nextcloud stores
	files in object storage as flat data-only blobs, so it's not just as simple
	as copying some files around.
</p>

<p>
	Ultimately, I ended up simply having a downtime event and manually
	re-syncing all the files for each user. This was still early on in our
	usage of Nextcloud--only dozens of gigabytes at most--so it wasn't a huge
	deal.
</p>

<p>
	With this, I now had a single server running Nextcloud, but with the
	benefits of more resilient storage, and an unlimited amount of it. I ran
	things this way for a while, but eventually the perceived risk of that
	single server wore me down. It was time to scale.
</p>

<h2>Stage Two: Kubernetes</h2>

<p>
	Obviously with Nextcloud being primarily filesystem-driven, just putting it
	on Kubernetes or using their official Docker images didn't really help
	much as we would still be bound to a single PVC containing the webroot.
</p>

<p>
	There were maybe a dozen different things I tried, from Azure
	Storage's CIFS integration in AKS, to running my own NFS server, and
	eventually settling on what I am currently running: <mark>webroot
	snapshots</mark>.
</p>

<p>
	Everything starts with a custom Docker image, which is mostly just a normal
	container with Apache HTTPD and PHP, running on an Alpine Linux base image.
	It was incredibly simple to get working, and contains a few dozen PHP
	extensions to maximize compatibility. I settled on this more generic
	approach because a lot of the world runs on PHP and while I try my best to
	avoid it, I may need to run some other PHP software in the future, and this
	leaves a door open.
</p>

<p>
	It's also probably worth noting this container currently sits at just over
	200MB, which is 73% smaller than the official Nextcloud images.
</p>

<p>
	<strong>Update:</strong> I have open-sourced this container image, if
	others want to use it directly or as a reference. You can find it on Github
	at <a href="https://github.com/alexblackie/prison">alexblackie/prison</a>.
</p>

<p>
	Inside of this PHP container I then place a couple of shell scripts: a
	container entrypoint, and one which generates a tarball of the webroot and
	stores it in object storage.
</p>

<p>
	This means that the container entrypoint fetches the webroot, extracts it,
	and only then starts HTTPD. By late-starting HTTPD synchronously, we can
	rely on Kubernetes' <code>readinessProbe</code>s to achieve zero-downtime
	rollouts. That entrypoint looks something like this:
</p>

<div class="code">
	<div class="code-title">start.sh</div>

```bash
#!/bin/sh
set -e

if [ "$WEBROOT_S3_URL" = "" ] ; then
	# [snip] some error message printing
	exit 1
fi

echo "Extracting webroot..."
aws s3 cp "$WEBROOT_S3_URL" /tmp/webroot.tar.gz
tar -xzf /tmp/webroot.tar.gz -C /srv/www
rm /tmp/webroot.tar.gz
chown -R apache:www-data /srv/www

echo "Starting httpd..."
/usr/sbin/httpd -D FOREGROUND -f /etc/apache2/httpd.conf
```
</div>

<p>
	With this, we need only set <code>WEBROOT_S3_URL</code> in the container
	environment to the full URL to the webroot tarball on S3. Then on boot it
	fetches and extracts that tarball, ensures that HTTPD can access it, and
	finally starts HTTPD.
</p>

<p>
	This is paired with another script for updating the tarball in S3 with what
	is currently in the webroot:
</p>

<div class="code">
	<div class="code-title">update-source.sh</div>

```bash
#!/bin/sh
set -e

cd /srv/www
	echo "Building source tarball..."
	tar -czf /tmp/webroot.tar.gz ./
	aws s3 cp /tmp/webroot.tar.gz "$WEBROOT_S3_URL"
cd -
```
</div>

<p>
	This script requires twofold:

	<ol>
		<li>You must make whatever changes you need on a single pod only, which
			if what you're doing involves load balanced UI means you
			either need more complex dynamic routing configuration, or
			accept the possibility of degraded performance as you scale
			replicas to 1.</li>
		<li>You must <code>exec</code> into the pod yourself, and manually
			execute this script.</li>
	</ol>
</p>

<p>
	Updating is still a bit of a pain point, because I still just scale
	everything to 1 replica to make sure my traffic hits the same pod
	every time. I am planning on investigating some sort of "sticky
	routing" with cookies or alternative hostnames so that I can target
	a specific pod without compromising the performance of the entire
	service. As of right now, that's still a future improvement,
	however.
</p>

<p>
	Regarding point #2 above, I am additionally considering building a
	small Nextcloud plugin which would let me trigger the update script
	from the Admin UI, thereby eliminating the need to manually
	<code>exec</code> into a pod. Again, as of right now, this is only a
	theoretical future endeavour.
</p>

<p>
	These very simple little scripts are what made all the difference for me,
	and were the final piece of the puzzle that allowed me to deploy Nextcloud
	with confidence.
</p>

<h2>Stage Three: Minio Gateway</h2>

<p>
	The move from the official Nextcloud Docker images to my own Alpine-based
	image provided a noticable improvement in performance. Intoxicated by this
	unexpected gain, I then looked at other improvements that could be made.
	One such change, which I am now running in production, is
	<mark>Minio Gateway</mark>.
</p>

<p>
	<a href="https://docs.min.io/docs/minio-gateway-for-s3.html">Minio Gateway for S3</a>
	can be configured to <mark>store local caches of objects</mark>,
	which can dramatically increase performance on heavy workloads such
	as Nextcloud. It also can lead to lower transfer costs, as hot
	objects served from the cache don't have to be repeatedly downloaded
	from S3, which can become expensive.
</p>

<p>
	Currently, Minio Gateway is running alongside Nextcloud in the same
	Kubernetes namespace, and is only available internally. Right now, I
	am taking advantage of the somewhat-generous temporary disk provided
	on the Kubernetes nodes I am running, and am mounting a temporary
	<code>emptyDir</code> into Minio's container. Since this data is
	ephemeral and its performance is not critical to running the app,
	the potential limits of temporary storage and the potential loss of
	the cache is unimportant. This gives me approximately 70GB of space
	to work with, which is plenty.
</p>

<p>
	Minio Gateway has a few other features that I have not yet
	experimented with, but plan to in the future. Namely, it can provide
	S3-compliant access to non-S3 object storage such as GCS or Azure
	Storage -- this means I am finally decoupled from AWS and can mirror
	or lift-and-shift my Nextcloud data to any object storage service
	supported by Minio Gateway, and have to change very little on the
	Nextcloud side.
</p>

<h2>... Profit?</h2>

<p>
	Now that everything is working and has been running smoothly for a
	while, I have been reaping the benefits. <mark>Nextcloud has been
	operating faster than it has ever been</mark>, and my trust in it has
	strengthened greatly.
</p>

<p>
	This new "decoupled" infrastructure also has helped to simplify and
	hone my backup strategies and disaster recovery scenarios, as all
	important data -- including configuration and the webroot -- can
	just be cloned from object storage to an off-site location.
</p>

<p>
	This also means I have reached the point where <mark>I can redeploy the
	service to any Kubernetes cluster in seconds</mark>, and restore the data
	to any object storage backend supported by Minio Gateway (I plan to
	document my DR strategies in a future article).
</p>

<p>
	I have always hesitated to commit fully to Nextcloud, simply because
	of how difficult it is to scale long-term without a multi-million
	dollar NetApp SAN. This collection of Docker containers, shell
	scripts, and object storage buckets now has now solved my concerns
	around scaling and performance, and I have never felt more confident
	about its resiliency.
</p>

<p>
	That said, I still have at least four backups at all time, in three
	different locations, and in two different formats. Just in case. I
	am confident, not foolish.
</p>
