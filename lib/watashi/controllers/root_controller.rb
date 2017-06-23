module Watashi
  module Controllers
    class RootController < AbstractController

      def get
        respond(template: "index", context: {
          page_title: "The Internet Sensation&trade;",
          stylesheets: ["home"],
          articles: Watashi::Domain::Article.catalogue
        })
      end

    end
  end
end
