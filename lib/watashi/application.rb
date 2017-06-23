module Watashi
  # The Rack-compatible entrypoint class. Acts as the router, sending the
  # request to the appropriate controller for handling.
  class Application

    ROUTE_MAP = {
      %r{^/$} => {class: "RootController", methods: ["GET"]},
      %r{^/assets/(?<name>.+)$} => {class: "StaticController", methods: ["GET"]}
    }.freeze

    def initialize
      Watashi::Config.populate(ENV["WATASHI_ENV"] || "development")
    end

    # Route a request to the correct controller based on the given data.
    #
    # @param path [String] the domain-relative path being requested.
    # @param env [Rack::Env] the full Rack environment
    # @return [Array] a Rack-compatible response array.
    def call(env)
      # Handle legacy routes by redirecting to new one
      if env["PATH_INFO"].end_with?(".shtml")
        new_path = env["PATH_INFO"].gsub(/\.shtml/, "")
        return [301, {"Location" => new_path}, [""]]
      end

      route = ROUTE_MAP.map do |exp, meta|
        next unless matches = env["PATH_INFO"].match(exp)
        meta.merge({captures: matches})
      end.compact.first

      unless route
        return Watashi::Controllers::ErrorsController.new(env).not_found
      end

      request_method = env["REQUEST_METHOD"]
      if route[:methods].include?(request_method)
        Object.const_get("Watashi::Controllers::#{route[:class]}")
          .new(env, route[:captures])
          .public_send(request_method.downcase)
      else
        Watashi::Controllers::ErrorsController.new(env).unsupported_method
      end
    end

  end
end
