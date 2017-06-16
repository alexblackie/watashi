module Watashi
  # The Rack-compatible entrypoint class. Acts as the router, sending the
  # request to the appropriate controller for handling.
  class Application

    ROUTE_MAP = {
      "/" => {class: "Watashi::Controllers::RootController", methods: ["GET"]},
    }.freeze

    # Route a request to the correct controller based on the given data.
    #
    # @param path [String] the domain-relative path being requested.
    # @param env [Rack::Env] the full Rack environment
    # @return [Array] a Rack-compatible response array.
    def call(env)
      request_method = env["REQUEST_METHOD"]
      path = "/" + env["SCRIPT_NAME"]
      route = ROUTE_MAP[path]

      if route[:methods].include?(request_method)
        Object.const_get(route[:class])
          .new(env)
          .public_send(request_method.downcase)
      else
        [405, {}, ["Error 405: Unsupported HTTP method.\n"]]
      end
    end

  end
end
