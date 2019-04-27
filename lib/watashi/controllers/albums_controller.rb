# frozen_string_literal: true

module Watashi
  module Controllers
    class AlbumsController < Yokunai::AbstractController

      def get
        service = Watashi::Services::DataBag.new(model: Watashi::Domain::Album)
        respond(template: "albums/index", context: {
                  page_title: "Photos",
                  albums: service.all,
                  stylesheets: ["albums"],
                  body_class: "page-albums"
                })
      end

    end
  end
end
