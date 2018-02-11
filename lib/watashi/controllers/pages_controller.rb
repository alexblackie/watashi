module Watashi
  module Controllers
    class PagesController < Yokunai::AbstractController

      def get
        slug = @captures[:slug]
        meta = Watashi::Services::DataBag.new(model: Watashi::Domain::Page).one(slug)

        if meta.nil?
          return respond(code: 404, template: "pages/404", context: {
            page_title: "HTTP 404: Resource Not Found",
            stylesheets: ["error"]
          })
        end

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
