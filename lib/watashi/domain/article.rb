module Watashi
  module Domain
    class Article

      PATH_KEY = "articles".freeze

      # @param file [Hash] the parsed yaml contents
      def initialize(data)
        @article = data
        @content_file = data["filename"].gsub(/\.yml/, ".html")
      end

      # @return [String] the URL slug of the article
      def id
        @article["id"]
      end

      # @return [String] The article title from meta
      def title
        @article["title"]
      end

      # @return [String] a ISO-8601 short formatted date from the article meta
      def date
        @article["date"]
      end

      # @return [String] a human-readable version of the date from the article meta
      def published_on
        @article["date"].strftime("%B %e, %Y")
      end

      # @return [String] the full HTML text of the article
      def content
        # We "lazily" don't read the file until here so we don't preload it in
        # the catalogue, saving a few cycles and memory.
        File.read(@content_file)
      end

      # @return [Array] list of custom stylesheets requested for this article
      def stylesheets
        @article["stylesheets"]
      end

      # @return [String] the URL slug to use to reference the article
      def slug
        @article["id"]
      end

    end
  end
end
