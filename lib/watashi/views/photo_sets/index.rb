module Watashi
  module Views
    module PhotoSets
      class Index

        include Hanami::View

        def page_title
          "Photos"
        end

        def stylesheets
          ["albums"]
        end

        def body_class
          "page-albums"
        end

      end
    end
  end
end
