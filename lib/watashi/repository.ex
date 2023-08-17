defmodule Watashi.Repository do
  @moduledoc """
  Provides an API for retrieving content from a content repository, generally
  the filesystem, with optional pluggable processing pipelines.

  ## Example

      defmodule Watashi.MyRepository do
        use Watashi.Repository,
          glob: "some_content/*.png",
          name: :my_repository,
          parser: &parser/2,
          sorter: &sorter/2
      end

  """

  defmacro __using__(opts) do
    quote do
      use GenServer

      def list(filters \\ []) do
        GenServer.call(unquote(opts[:name]), {:list, filters})
      end

      def one(id) do
        GenServer.call(unquote(opts[:name]), {:one, id})
      end

      def start_link(init_opts) do
        GenServer.start_link(__MODULE__, init_opts, name: unquote(opts[:name]))
      end

      @impl GenServer
      def init(_init_opts) do
        parser = unquote(opts[:parser])
        sorter = unquote(opts[:sorter])
        glob = unquote(opts[:glob])

        entries =
          Path.wildcard(glob)
          |> Enum.map(&parser.(&1, File.read!(&1)))
          |> Enum.sort(sorter)

        entries_index =
          entries
          |> Enum.map(fn a -> {a.id, a} end)
          |> Enum.into(%{})

        {:ok, %{entries_index: entries_index, entries: entries}}
      end

      @impl GenServer
      def handle_call({:list, _filters}, _caller, state) do
        {:reply, {:ok, state.entries}, state}
      end

      @impl GenServer
      def handle_call({:one, id}, _caller, state) do
        result =
          state.entries_index
          |> Map.get(id)
          |> case do
            nil -> {:error, :not_found}
            entry -> {:ok, entry}
          end

        {:reply, result, state}
      end
    end
  end
end
