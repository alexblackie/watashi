title: Simple configuration for UUID primary keys in Ecto
slug: simple-config-uuids-ecto
publish_date: "2021-01-20"

open_graph_meta:
  title: Simple configuration for UUID primary keys in Ecto
  description: >
    UUID primary keys don't have to be a pain when using Ecto in your Elixir
    projects.

---

Using UUID's as primary keys can have many benefits, and if you're using PostgreSQL you have the advantage of solid performance and efficient storage of those UUIDs leading to good scalability even compared to `bigint`.

With [Ecto][0], using UUID primary keys is very easy, however most guides out there are still written for Ecto 1.x or 2.x -- in modern times using UUIDs is _even easier_ with Ecto 3+.

[0]: https://github.com/elixir-ecto/ecto/

In your `config.exs`, simply configure your repo to use the `:binary_id` by default for primary keys and foreign keys:

```elixir
config :my_app, MyApp.Repo,
  migration_primary_key: [name: :id, type: :binary_id],
  migration_foreign_key: [column: :id, type: :binary_id]
```

You don't have to modify your migrations at all; Ecto will use UUIDs for keys unless you tell it otherwise, just as it was previously with `bigint` keys.

The only other required step is to annotate your schemas so they use `:binary_id` as well. You can do this on each individually, but I generally prefer to do this in a behaviour that wraps `Ecto.Schema`. For example,

```elixir
defmodule MyApp.Schema do
  @moduledoc """
  Behaviour to replace `Ecto.Schema` to set some defaults across all schemas in
  the codebase -- namely, UUID primary keys.
  """

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
```

Then you can use this in your schemas:

```elixir
defmodule MyApp.User do
  use MyApp.Schema

  ...
end
```

And that's all there is to it! I hope this helped you avoid setting `primary_key: false` in every migration you write.
