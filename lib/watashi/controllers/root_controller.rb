module Watashi
  module Controllers
    class RootController < Yokunai::AbstractController

      DEFAULT_PER_PAGE = 8.freeze

      def get
        page = (request.params["page"] || 0).to_i
        service = Watashi::Services::DataBag.new(model: Watashi::Domain::Article)
        articles = service.all(
          sort: :date,
          per_page: DEFAULT_PER_PAGE,
          page: page
        )

        respond(template: "index", context: {
          page_title: "The Internet Sensation&trade;",
          stylesheets: ["home"],
          articles: articles,
          current_page: page,
          total_pages: service.total_pages(per_page: DEFAULT_PER_PAGE),
          body_class: "page-home",
          full_width: true
        })
      end

    end
  end
end
