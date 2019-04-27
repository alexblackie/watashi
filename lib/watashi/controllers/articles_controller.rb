# frozen_string_literal: true

module Watashi
  module Controllers
    class ArticlesController < Yokunai::AbstractController

      def get
        article = Watashi::Services::DataBag
                  .new(model: Watashi::Domain::Article)
                  .one(@captures[:slug])

        return respond_error(:not_found) unless article

        respond(template: "article_show", context: {
                  body_class: "page-article",
                  body: article.content,
                  page_title: article.title,
                  date: article.published_on,
                  stylesheets: article.stylesheets,
                  javascripts: ["article"],
                  toc: article.toc,
                  full_width: !article.toc.nil?,
                  held: article.held?,
                  cover: article.cover,
                  photostrip: article.photostrip,
                  og_meta: article.og_meta
                })
      end

    end
  end
end
