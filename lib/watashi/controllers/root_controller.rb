module Watashi
  module Controllers
    class RootController < AbstractController

      def get
        respond(template: "index", context: {
          page_title: "The Internet Sensation&trade;",
          stylesheets: ["home"],
          articles: Watashi::Domain::Article.catalogue,
          body_class: "page-home"
        })
      end

    end
  end
end
