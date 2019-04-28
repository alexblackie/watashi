# frozen_string_literal: true

module Watashi
  module Views
    module Articles
      class Show

        include Hanami::View

        def body_class
          "page-article"
        end

        def body
          _raw article.content
        end

        def page_title
          article.title
        end

        def date
          article.published_on
        end

        def stylesheets
          article.stylesheets
        end

        def toc
          article.toc
        end

        def full_width
          !article.toc.nil?
        end

        def held
          article.held?
        end

        def cover
          article.cover
        end

        def photostrip
          article.photostrip
        end

        def og_meta
          article.og_meta
        end

        def javascripts
          ["article"]
        end

      end
    end
  end
end
