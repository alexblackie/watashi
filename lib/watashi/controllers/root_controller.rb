module Watashi
  module Controllers
    class RootController < AbstractController

      def get
        respond(template: "index")
      end

    end
  end
end
