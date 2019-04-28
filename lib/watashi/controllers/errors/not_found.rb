module Watashi
  module Controllers
    module Errors
      class NotFound

        include Hanami::Action

        def call(params)
          self.status = 404
          slug = 404
          meta = Watashi::Domain::Page.new({
            "title" => "Error 404: Resource Not Found",
            "stylesheets" => ["error"]
          })

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
