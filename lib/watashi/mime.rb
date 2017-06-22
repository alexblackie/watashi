module Watashi
  # Provides a light wrapper around MimeMagic to make it a little easier to use.
  class Mime

    # Detect the mime type from the given path string.
    #
    # @param path [String] the path
    # @return [String] the mime type string
    def self.detect_from_path(path, fallback = "text/plain")
      mime = MimeMagic.by_path(path)
      mime ? mime.type : fallback
    end

  end
end
