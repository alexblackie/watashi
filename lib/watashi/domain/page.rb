module Watashi
  module Domain
    class Page

      PATH_KEY = "pages".freeze

      attr_reader :id, :title, :stylesheets, :javascripts

      # @param data [Hash] the YAML data hash
      def initialize(data)
        @id = data["id"]
        @title = data["title"]
        @stylesheets = data["stylesheets"] || []
        @javascripts = data["javascripts"] || []
      end

    end
  end
end
