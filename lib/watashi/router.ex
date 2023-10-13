defmodule Watashi.Router do
  use Plug.Router

  plug(LoggerJSON.Plug)
  plug(Plug.Static, from: {:watashi, "priv/static"}, at: "/")

  plug(:match)
  plug(:dispatch)

  get "/" do
    {:ok, articles} = Watashi.ArticleRepository.list()

    body =
      Watashi.Template.render_layout(
        "home.html",
        title: "Software developer and entrepreneur",
        articles: articles
      )

    send_resp(conn, 200, body)
  end

  get "/articles/:slug" do
    with {:ok, article} <- Watashi.ArticleRepository.one(conn.params["slug"]) do
      body =
        Watashi.Template.render_layout(
          "article.html",
          title: article.title,
          article: article
        )

      send_resp(conn, 200, body)
    else
      {:error, :not_found} -> send_resp(conn, 404, "Not found!")
    end
  end

  match _ do
    send_resp(conn, 404, "Not found!")
  end
end
