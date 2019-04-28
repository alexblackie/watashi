# frozen_string_literal: true

module Watashi
  module Domain
    class Album

      PATH_KEY = "albums"

      attr_reader :id, :title, :publish_date, :photo_sets

      # @param data [Hash] the YAML data hash
      def initialize(data)
        @id = data["id"]
        @title = data["title"]
        @publish_date = data["publish_date"]
        @photo_sets = data["photo_sets"].map do |id|
          Watashi::Services::DataBag.new(model: Watashi::Domain::PhotoSet).one(id)
        end
      end

      # Generate a URL to the cover photo for this album.
      #
      # @return [String]
      def cover_photo_url
        "#{ Watashi::CDN_BASE }/photos/#{ @id }.jpg"
      end

    end
  end
end
