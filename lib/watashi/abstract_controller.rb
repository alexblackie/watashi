module Watashi
  class AbstractController

    # --------------------------------------------------------------------------
    # Constants
    # --------------------------------------------------------------------------

    DEFAULT_HEADERS = {
      "Content-Type" => "text/html",
      "Server" => "watashi/1.0"
    }


    # --------------------------------------------------------------------------
    # Instance Methods
    # --------------------------------------------------------------------------

    def initialize(env)
      @env = env
      @templates = Watashi::Template.new
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
        body = @templates.render("index")
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
