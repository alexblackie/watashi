module Watashi
  module Controllers
    class PagesController < AbstractController

      def get
        respond(template: "pages/#{@captures[:slug]}", context: {
          page_title: "My Setup",
          body_class: "page-#{@captures[:slug]}"
        })
      end

    end
  end
end
