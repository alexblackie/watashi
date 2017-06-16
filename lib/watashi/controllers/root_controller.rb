module Watashi
  module Controllers
    class RootController < AbstractController

      def get
        respond(body: "it werks")
      end

    end
  end
end
