module Watashi
  # Renders ERB templates and caches them in-memory.
  class Template

    DEFAULT_TEMPLATE_PATH = File.join(File.dirname(__FILE__), "..", "..", "web", "views")

    def initialize(template_path: DEFAULT_TEMPLATE_PATH)
      @renders = {}
      @template_path = template_path
    end

    # Render an ERB template with the given name, and cache the result for
    # subsequent calls.
    #
    # @param template [String] the name of a template
    # @return [String] the ERB render result
    def render(template)
      return @renders[template] if @renders[template]

      path = File.join(@template_path, template + ".erb")
      return nil unless File.exist?(path)

      template_string = File.read(path)
      @renders[template] = ERB.new(template_string).result
    end

  end
end
