module Watashi
  module Services
    # A Data Bag represents a collection of YAML that contains serial data.
    # This could be articles, photos, podcasts--doesn't matter. Just give it a
    # model that conforms the expected interface and it'll provide some
    # conveience methods for accessing the data.
    class DataBag

      attr_reader :base_dir

      # @param model [Class] the model class; must have at least a `.path_key` method; will be instantiated with the yaml data
      # @param base_dir [String] the absolute path to the application base directory (optional)
      def initialize(model:, base_dir: Yokunai::Config.base_dir)
        @base_dir = File.join(base_dir, "data", model::PATH_KEY)
        @model = model
      end

      # Return model instances for all entries in the data bag.
      #
      # @param sort [Symbol] call this method and use its return value to sort
      # @param per_page [Integer] Number of items to return
      # @param page [Integer] Number of items to skip
      # @return [Array] list of instances of the given model
      def all(sort: :id, per_page: 10, page: 0)
        per_page = 1 if per_page <= 0
        offset = 0
        offset = page * per_page if page > 0
        next_offset = offset + (per_page - 1)

        return [] if page > total_pages(per_page: per_page)

        results = get_all()
        .sort{|lhs, rhs| lhs.public_send(sort) <=> rhs.public_send(sort) }
        .reverse
        .slice(offset..next_offset)

        results ? results : []
      end

      # Find a single record in the data bag.
      #
      # @param id [String] the UUID of the record
      # @return [Class|nil] an instance of the model, or nil if not found
      def one(id)
        path = File.join(@base_dir, "#{ id }.yml")
        return nil unless File.exist?(path)
        @model.new(read_yaml(path))
      end

      # @param per_page [Integer] Total pages, given per_page number of pages
      def total_pages(per_page:)
        (get_all().size / per_page).round
      end

      private

      def read_yaml(file)
        YAML.load_file(file).merge({
          "id" => File.basename(file).gsub(/\.yml/, ""),
          "filename" => file
        })
      end

      def get_all
        @entities ||= Dir
        .glob(File.join(@base_dir, "*.yml"))
        .map{ |f| @model.new(read_yaml(f)) }
      end

    end
  end
end
