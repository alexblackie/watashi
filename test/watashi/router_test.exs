defmodule Watashi.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "GET /" do
    response = conn(:get, "/") |> Watashi.Router.call([])

    assert response.status == 200
    assert response.resp_body =~ "github.com/alexblackie"
    assert response.resp_body =~ "Email Authenticity"
  end

  test "GET /articles/:slug" do
    response =
      conn(:get, "/articles/email-authenticity-dkim-spf-dmarc/")
      |> Watashi.Router.call([])

    assert response.status == 200
    assert response.resp_body =~ "a lot of the burden of authenticity"
  end

  test "GET 404 /articles/:slug" do
    response =
      conn(:get, "/articles/thisisnotandwillneverbearouteihope/")
      |> Watashi.Router.call([])

    assert response.status == 404
    assert response.resp_body =~ "Not found"
  end

  test "GET 404 error" do
    response =
      conn(:get, "/thisisnotandwillneverbearouteihope/")
      |> Watashi.Router.call([])

    assert response.status == 404
    assert response.resp_body =~ "Not found"
  end
end
