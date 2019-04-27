# frozen_string_literal: true

module Watashi
  module Controllers
    module Pages
      class Show

        include Hanami::Action

        def call(params)
          slug = params[:id]
          meta = Watashi::Services::DataBag.new(model: Watashi::Domain::Page).one(slug)

          if meta.nil?
            # If we couldn't find a page from the data bag, set the # page to
            # be the error page and change the HTTP response code.

            self.status = 404
            slug = 404
            meta = Watashi::Domain::Page.new({
              title: "HTTP 404: Resource Not Found",
              stylesheets: ["error"]
            })
          end

          ctx = {
            format: :html,
            page_meta: meta,
            slug: slug
          }

          self.body = Watashi::Views::Pages::Show.render(ctx)
        end

      end
    end
  end
end
