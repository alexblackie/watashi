# frozen_string_literal: true

module Watashi
  module Views
    module Rss
      class Index

        include Hanami::View

        layout false
        format :xml

      end
    end
  end
end
