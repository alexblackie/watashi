module Watashi
  module Controllers
    class ArticlesController < AbstractController

      def get
        article = Watashi::Domain::Article.find(@captures[:slug])
        return respond_error(:not_found) unless article

        respond(template: "article_show", context: {
          body: article.content,
          page_title: article.title,
          date: article.published_on,
          stylesheets: article.stylesheets
        })
      end

    end
  end
end
