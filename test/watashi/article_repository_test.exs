defmodule Watashi.ArticleRepositoryTest do
  use ExUnit.Case, async: true

  test "parser/2 with markdown and frontmatter" do
    data = """
    title: In support of cats
    publish_date: "2069-04-20"
    ---

    Despite what they've done, they _might_ still be worth supporting.
    """

    article = Watashi.ArticleRepository.parser("cats.md", data)

    assert "In support of cats" == article.title
    assert ~D{2069-04-20} == article.published_at
    assert is_nil(article.updated_at)
    assert is_nil(article.cover)
    assert article.rendered_content =~ "they <em>might</em> still"
    assert article.content =~ "they _might_ still"
  end

  test "parser/2 with HTML and frontmatter" do
    data = """
    title: We must rise up against cats
    publish_date: "2072-04-20"
    ---

    <p>
      The aggression against humanity's continued existence from the rebel
      feline forces <strong>must be quelled</strong> if we are to survive.
    </p>
    """

    article = Watashi.ArticleRepository.parser("rise-up.html", data)

    assert "We must rise up against cats" == article.title
    assert ~D{2072-04-20} == article.published_at
    assert is_nil(article.updated_at)
    assert is_nil(article.cover)
    assert article.rendered_content =~ "forces <strong>must be quelled"
    assert article.content =~ "forces <strong>must be quelled"
  end

  test "parser/2 with all supported metadata present" do
    data = """
    title: Some Article
    publish_date: 2001-09-11
    updated_at: 2008-09-11

    cover:
      url: https://cdn/some_image.png
      alt: "An image"
      width: 100
      height: 50

    open_graph_meta:
      title: Some Article
      description: >
        You won't believe what they did!

    ---

    asdfasdfasdf
    """

    article = Watashi.ArticleRepository.parser("test.md", data)

    assert "Some Article" == article.title
    assert ~D{2001-09-11} == article.published_at
    assert ~D{2008-09-11} == article.updated_at
    assert %Watashi.CoverPhoto{} = cover = article.cover
    assert "https://cdn/some_image.png" == cover.url
    assert "An image" == cover.alt
    assert 100 = cover.width
    assert 50 == cover.height
  end
end
