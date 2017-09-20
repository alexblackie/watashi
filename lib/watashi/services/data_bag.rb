module Watashi
  module Services
    # A Data Bag represents a collection of YAML that contains serial data.
    # This could be articles, photos, podcasts--doesn't matter. Just give it a
    # model that conforms the expected interface and it'll provide some
    # conveience methods for accessing the data.
    class DataBag

      # @param model [Class] the model class; must have at least a `.path_key` method; will be instantiated with the yaml data
      # @param base_dir [String] the absolute path to the application base directory (optional)
      def initialize(model:, base_dir: Yokunai::Config.base_dir)
        @base_dir = File.join(base_dir, "data", model::PATH_KEY)
        @model = model
      end

      # Return model instances for all entries in the data bag.
      #
      # @return [Array] list of instances of the given model
      def all
        Dir.glob(File.join(@base_dir, "*.yml")).map do |f|
          @model.new(YAML.load_file(f))
        end
      end

      # Find a single record in the data bag.
      #
      # @param id [String] the UUID of the record
      # @return [Class|nil] an instance of the model, or nil if not found
      def one(id)
        path = File.join(@base_dir, "#{ id }.yml")
        return nil unless File.exist?(path)
        @model.new(YAML.load_file(path))
      end

    end
  end
end
