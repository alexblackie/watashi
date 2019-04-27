module Watashi
  module Views
    module Pages
      class Show

        include Hanami::View

        def page_title
          page_meta.title
        end

        def body_class
          "page-#{ slug }"
        end

        def stylesheets
          page_meta.stylesheets
        end

        def javascripts
          page_meta.javascripts
        end

        def template
          path = Hanami::View.configuration.root.join("watashi/views/pages/#{ slug }.html.erb")
          Hanami::View::Template.new(path)
        end

      end
    end
  end
end
