defmodule Watashi.Article do
  @type t :: %__MODULE__{
          id: binary(),
          title: binary(),
          content: binary(),
          rendered_content: binary(),
          cover: Watashi.CoverPhoto.t(),
          published_at: Date.t(),
          updated_at: Date.t()
        }

  defstruct id: "",
            title: "",
            content: "",
            rendered_content: "",
            cover: nil,
            published_at: Date.from_iso8601!("1970-01-01"),
            updated_at: Date.from_iso8601!("1970-01-01")

  @doc """
  Populate a new Article struct with the values from the given map. The map is
  expected to have string keys, assumed to be parsed from some file or API.

  ## Examples

      iex> from(%{"title" => "Test"})
      %Article{title: "Test"}

  """
  def from(meta) do
    %__MODULE__{
      id: meta["id"],
      title: meta["title"],
      published_at: meta["publish_date"] |> parse_date(),
      updated_at: meta["updated_at"] |> parse_date()
    }
  end

  defp parse_date(value) when is_nil(value), do: nil

  defp parse_date(value) do
    case Date.from_iso8601(value) do
      {:ok, date} -> date
      {:error, _} -> nil
    end
  end
end
