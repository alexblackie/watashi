module Watashi
  # The Rack-compatible entrypoint class. Acts as the router, sending the
  # request to the appropriate controller for handling.
  class Application

    ROUTE_MAP = {
      %r{^/$} => {class: "RootController", methods: ["GET"]}
    }.freeze

    # Route a request to the correct controller based on the given data.
    #
    # @param path [String] the domain-relative path being requested.
    # @param env [Rack::Env] the full Rack environment
    # @return [Array] a Rack-compatible response array.
    def call(env)
      request_method = env["REQUEST_METHOD"]
      route = ROUTE_MAP.detect do |reg, target|
        env["PATH_INFO"].match(reg)
      end[1]

      unless route
        return Watashi::Controllers::ErrorsController.new(env).not_found
      end

      if route[:methods].include?(request_method)
        Object.const_get("Watashi::Controllers::#{route[:class]}")
          .new(env)
          .public_send(request_method.downcase)
      else
        Watashi::Controllers::ErrorsController.new(env).unsupported_method
      end
    end

  end
end
