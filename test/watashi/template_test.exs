defmodule Watashi.TemplateTest do
  use ExUnit.Case, async: true

  test "render/2 renders a template" do
    html = Watashi.Template.render("home.html", articles: [])
    assert html =~ ~s{<div class="homeHero">}
    assert html =~ ~s{<ul class="articleList">}
  end

  test "render/2 renders a template without assigns" do
    html = Watashi.Template.render("test.html")
    assert html =~ "Test template"
  end

  test "render_layout/2 renders a template wrapped in the layout" do
    html = Watashi.Template.render_layout("home.html", articles: [])
    assert html =~ ~s{<title>}
    assert html =~ ~s{<div class="homeHero">}
    assert html =~ ~s{<ul class="articleList">}
  end
end
