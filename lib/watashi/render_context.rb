module Watashi
  # Provides a clean binding and basic API to add variables to it. Meant to be
  # used only for template rendering.
  class RenderContext

    # Instantiate a new instance and create local variables for the key/value
    # pairs in the given hash.
    #
    # @param context [Hash] variables to set on the local binding
    # @return [Watashi::RenderContext]
    def initialize(context = {})
      @binding = binding

      context.each do |key, value|
        @binding.local_variable_set(key, value)
      end
    end

    # Returns the binding of this class, with the variables that have been set.
    def get_binding
      @binding
    end

    # Sort of a hack, since if a var doesn't exist it will try and call a method
    # and so we'll end up here...
    def method_missing(m, *args, &block)
      "No such context key: #{m}"
    end

  end
end
