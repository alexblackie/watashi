module Watashi
  module Controllers
    class AlbumController < Yokunai::AbstractController

      def get
        album = Watashi::Services::DataBag
          .new(model: Watashi::Domain::Album).one(@captures[:id])

        respond(template: "albums/show", context: {
          page_title: album.title,
          album: album,
          stylesheets: ["albums"],
          body_class: "page-albums"
        })
      end

    end
  end
end
