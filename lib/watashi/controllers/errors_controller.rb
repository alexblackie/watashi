module Watashi
  module Controllers
    class ErrorsController < AbstractController

      def not_found
        respond(code: 404, body: "Error 404: Could not locate resource.")
      end

      def unsupported_method
        respond(code: 405, body: "Error 405: Unsupported HTTP method.")
      end

    end
  end
end
