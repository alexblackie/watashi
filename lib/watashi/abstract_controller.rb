module Watashi
  class AbstractController

    DEFAULT_HEADERS = {
      "Content-Type" => "text/html",
      "Server" => "watashi/1.0"
    }

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

    def respond(code: 200, headers: {}, body: "")
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
