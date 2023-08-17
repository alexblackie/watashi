defmodule Watashi.CoverPhotoTest do
  use ExUnit.Case, async: true

  test "from/1" do
    %Watashi.CoverPhoto{} =
      cover =
      %{
        "url" => "https://example.com/image.png",
        "alt" => "Some alt text",
        "width" => 512,
        "height" => 128
      }
      |> Watashi.CoverPhoto.from()

    assert "https://example.com/image.png" == cover.url
    assert "Some alt text" == cover.alt
    assert 512 == cover.width
    assert 128 == cover.height
  end
end
