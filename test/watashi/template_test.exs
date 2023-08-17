defmodule Watashi.TemplateTest do
  use ExUnit.Case, async: true

  test "render/2" do
    # Using the homepage as a test subject since we don't have any
    # test-specific pages. This ties these tests to the content of the
    # homepage which I don't love, but it's still a test.
    html = Watashi.Template.render("home.html", articles: [])
    assert html =~ ~s{<div class="homeHero">}
    assert html =~ ~s{<ul class="articleList">}
  end
end
