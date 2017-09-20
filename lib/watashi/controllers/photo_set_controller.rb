module Watashi
  module Controllers
    class PhotoSetController < Yokunai::AbstractController

      def get
        album = Watashi::Services::DataBag
          .new(model: Watashi::Domain::Album).one(@captures[:album_id])
        photo_set = Watashi::Services::DataBag
          .new(model: Watashi::Domain::PhotoSet).one(@captures[:id])

        respond(template: "photo_set/show", context: {
          page_title: "#{ photo_set.title } - #{ album.title }",
          stylesheets: ["albums"],
          javascripts: ["masonry.min", "albums"],
          body_class: "page-photoset",
          album: album,
          photo_set: photo_set
        })
      end

    end
  end
end
