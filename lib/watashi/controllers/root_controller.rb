module Watashi
  module Controllers
    class RootController < Yokunai::AbstractController

      def get
        articles = Watashi::Services::DataBag
          .new(model: Watashi::Domain::Article).all(sort: :date).reverse

        respond(template: "index", context: {
          page_title: "The Internet Sensation&trade;",
          stylesheets: ["home"],
          articles: articles,
          body_class: "page-home",
          full_width: true
        })
      end

    end
  end
end
