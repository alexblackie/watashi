defmodule WatashiTest do
  use ExUnit.Case
  doctest Watashi

  test "greets the world" do
    assert Watashi.hello() == :world
  end
end
