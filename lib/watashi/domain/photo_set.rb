module Watashi
  module Domain
    class PhotoSet

      PATH_KEY = "photo_sets".freeze

      attr_reader :id, :title, :description, :photos, :album_id

      # @param data [Hash] the yaml data hash
      def initialize(data)
        @id = data["id"]
        @title = data["title"]
        @description = data["description"]
        @photos = data["photos"]
        @album_id = data["album_id"]
      end

      # Return FQDN URLs to each photo ID listed in the YAML.
      #
      # @return [Array<String>]
      def photo_urls
        @photos.map do |id|
          "#{ Yokunai::Config.get("cdn_base") }/#{ @album_id }/#{ id }.jpg"
        end
      end

    end
  end
end
