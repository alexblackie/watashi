module Watashi
  # Renders ERB templates.
  class Template

    DEFAULT_TEMPLATE_PATH = File.join(File.dirname(__FILE__), "..", "..", "web", "views")

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

      context.merge!({
        partial: ERB.new(File.read(path)).result
      })

      render_context = Watashi::RenderContext.new(context)
      ERB.new(@raw_layout).result(render_context.get_binding)
    end

  end
end
