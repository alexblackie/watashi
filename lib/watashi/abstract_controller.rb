module Watashi
  class AbstractController

    # --------------------------------------------------------------------------
    # Constants
    # --------------------------------------------------------------------------

    DEFAULT_HEADERS = {
      "Content-Type" => "text/html",
      "Server" => "watashi/1.0"
    }

    TEMPLATE_PATH = File.join(File.dirname(__FILE__), "..", "..", "web", "views")


    # --------------------------------------------------------------------------
    # Instance Methods
    # --------------------------------------------------------------------------

    def initialize(env)
      @env = env
    end


    # --------------------------------------------------------------------------
    # Default HTTP method handlers
    # --------------------------------------------------------------------------

    def get
      unsupported_method
    end

    def post
      unsupported_method
    end

    def put
      unsupported_method
    end

    def patch
      unsupported_method
    end

    def delete
      unsupported_method
    end

    def options
      unsupported_method
    end

  private

    def respond(code: 200, headers: {}, body: "", template: nil)
      if template
        template_string = File.read(File.join(TEMPLATE_PATH, template + ".erb"))
        # TODO: should probably cache this result
        body = ERB.new(template_string).result
      end

      [
        code,
        DEFAULT_HEADERS.merge(headers),
        [body]
      ]
    end

    def unsupported_method
      [405, {}, ["Error 405: Method not supported on this resource.\n"]]
    end

  end
end
