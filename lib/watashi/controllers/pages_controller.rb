module Watashi
  module Controllers
    class PagesController < AbstractController

      def get
        respond(template: "pages/#{@captures[:slug]}", context: {
          page_title: "My Setup"
        })
      end

    end
  end
end
