module Watashi
  module Controllers
    class PagesController < Yokunai::AbstractController

      def get
        slug = @captures[:slug]
        meta = Watashi::Services::DataBag.new(model: Watashi::Domain::Page).one(slug)

        respond(template: "pages/#{slug}", context: {
          page_title: meta.title,
          body_class: "page-#{slug}",
          stylesheets: meta.stylesheets,
          javascripts: meta.javascripts
        })
      end

    end
  end
end
