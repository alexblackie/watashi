module Watashi
  module Views
    module PhotoSets
      class Show

        include Hanami::View

        def page_title
          "#{ photo_set.title } - #{ album.title }"
        end

        def stylesheets
          ["albums"]
        end

        def javascripts
          ["imagesloaded.min", "masonry.min", "albums"]
        end

        def body_class
          "page-photoset"
        end

      end
    end
  end
end
