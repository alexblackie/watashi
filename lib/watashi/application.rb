module Watashi
  # The Rack-compatible entrypoint class. Acts as the router, sending the
  # request to the appropriate controller for handling.
  class Application

    ROUTE_MAP = {
      "/" => "Watashi::Controllers::RootController"
    }.freeze

    # Route a request to the correct controller based on the given data.
    #
    # @param path [String] the domain-relative path being requested.
    # @param env [Rack::Env] the full Rack environment
    # @return [Array] a Rack-compatible response array.
    def call(env)
      path = "/" + env["SCRIPT_NAME"]
      Object.const_get(ROUTE_MAP[path])
        .new(env)
        .public_send(env["REQUEST_METHOD"].downcase.to_sym)
    end

  end
end
