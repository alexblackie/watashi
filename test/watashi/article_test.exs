defmodule Watashi.ArticleTest do
  use ExUnit.Case, async: true

  @valid_attrs %{
    "id" => "test-article",
    "title" => "Test Article",
    "publish_date" => "2020-03-16",
    "updated_at" => "2021-04-20"
  }

  @invalid_attrs %{
    "id" => "test-article",
    "title" => "Test Article",
    "publish_date" => "soon",
    "updated_at" => "2021-04-20"
  }

  test "from/1" do
    article = @valid_attrs |> Watashi.Article.from()

    assert %Watashi.Article{} = article
    assert "test-article" == article.id
    assert "Test Article" == article.title
    assert ~D[2020-03-16] == article.published_at
    assert ~D[2021-04-20] == article.updated_at
  end

  test "from/1 with a bad date" do
    article = @invalid_attrs |> Watashi.Article.from()

    assert %Watashi.Article{} = article
    assert "test-article" == article.id
    assert "Test Article" == article.title
    assert is_nil(article.published_at)
  end
end
