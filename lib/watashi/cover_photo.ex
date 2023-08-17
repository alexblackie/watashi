defmodule Watashi.CoverPhoto do
  @type t :: %__MODULE__{
          url: binary(),
          alt: binary(),
          width: integer(),
          height: integer()
        }

  defstruct url: "",
            alt: "",
            width: 0,
            height: 0

  @doc """
  Populate a new CoverPhoto struct with the values from the given map. The map
  is expected to have string keys, assumed to be parsed from some file or API.

  ## Examples

      iex> from(%{"url" => "http://test.png"})
      %CoverPhoto{url: "http://test.png"}

  """
  def from(cover) do
    %Watashi.CoverPhoto{
      url: cover["url"],
      alt: cover["alt"],
      width: cover["width"],
      height: cover["height"]
    }
  end
end
