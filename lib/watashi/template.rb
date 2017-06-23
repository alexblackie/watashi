module Watashi
  # Renders ERB templates.
  class Template

    DEFAULT_TEMPLATE_PATH = File.join(Watashi::BASE_DIR, "web", "views").freeze

    def initialize(template_path: DEFAULT_TEMPLATE_PATH)
      @template_path = template_path
      @raw_layout = File.read(File.join(@template_path, "layout.erb"))
    end

    # Render an ERB template with the given name, and cache the result for
    # subsequent calls.
    #
    # @param template [String] the name of a template
    # @param context [Hash] key/value pairs of variables to bind the template
    # @return [String] the ERB render result
    def render(template, context = {})
      path = File.join(@template_path, template + ".erb")
      return nil unless File.exist?(path)

      layout_context = context.merge({
        partial: ERB.new(File.read(path)).result(Watashi::RenderContext.new(context).get_binding)
      })

      ERB.new(@raw_layout).result(Watashi::RenderContext.new(layout_context).get_binding)
    end

  end
end
