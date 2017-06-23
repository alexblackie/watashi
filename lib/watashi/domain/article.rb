module Watashi
  module Domain
    class Article

      CATALOGUE_PATH = File.join(Watashi::BASE_DIR, "web", "articles")

      # Returns an array of all articles.
      #
      # @param path [String] optionally override where to look for articles.
      # @return [Array<Watashi::Domain::Article>]
      def self.catalogue(path = CATALOGUE_PATH)
        Dir
          .glob(File.join(path, "*.yml"))
          .delete_if{|d| d == "." || d == ".." }
          .map{|f| Article.new(f) }
          .sort{|a, b| b.date <=> a.date}
      end

      # Finds and instantiates an article based on extensionless slug.
      #
      # @param path [String] optionally override where to look for articles.
      # @return [Watashi::Domain::Article|nil]
      def self.find(slug, path = CATALOGUE_PATH)
        file = File.join(path, "#{slug}.yml")
        return nil unless File.exist?(file)
        new(file)
      end

      # @param file [String] the full path on the filesystem to an article
      def initialize(file)
        @file = file
        @article = YAML.load_file(@file)
        @search_path = File.dirname(@file)
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
        @article["date"].strftime("%B %d, %Y")
      end

      # @return [String] the full HTML text of the article
      def content
        # We "lazily" don't read the file until here so we don't preload it in
        # the catalogue, saving a few cycles and memory.
        File.read(File.join(@search_path, "#{slug}.html"))
      end

      # @return [Array] list of custom stylesheets requested for this article
      def stylesheets
        @article["stylesheets"]
      end

      # @return [String] the URL slug to use to reference the article
      def slug
        File.basename(@file).gsub(/\.yml/, "")
      end

    end
  end
end
