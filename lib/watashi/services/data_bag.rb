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
      # @return [Array] list of instances of the given model
      def all(sort: :id)
        Dir.glob(File.join(@base_dir, "*.yml")).map do |f|
          @model.new(read_yaml(f))
        end.sort{|lhs, rhs| lhs.public_send(sort) <=> rhs.public_send(sort) }
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

      private

      def read_yaml(file)
        YAML.load_file(file).merge({
          "id" => File.basename(file).gsub(/\.yml/, ""),
          "filename" => file
        })
      end

    end
  end
end
