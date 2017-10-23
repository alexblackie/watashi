module Watashi
  module Controllers
    class DpiAppController < Yokunai::AbstractController

      def get
        respond(template: "dpi", context: {
          page_title: "Screen DPI calculator",
          stylesheets: ["dpi"],
          javascripts: ["dpi"]
        })
      end

    end
  end
end
