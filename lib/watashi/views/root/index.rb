# frozen_string_literal: true

module Watashi
  module Views
    module Root
      class Index

        include Hanami::View

        def page_title
          "The Internet Sensation™"
        end

        def stylesheets
          ["home"]
        end

        def body_class
          "page-home"
        end

        def full_width
          true
        end

      end
    end
  end
end
