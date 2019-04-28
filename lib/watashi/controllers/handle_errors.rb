module Watashi
  module Controllers
    # Mixin to handle common errors and render rich HTML pages for them.
    #
    # Simply `raise` one of these error classes, and `include` this module into
    # your controller action class to use:
    #
    #     class Show
    #       include Hanami::Action
    #       include Watashi::Controllers::HandleErrors
    #
    #       def call(_)
    #         raise Watashi::Errors::RecordNotFound
    #       end
    #     end
    module HandleErrors

      HANDLER_MAP = {
        Watashi::Errors::RecordNotFound => :handle_not_found
      }

      def self.included(base)
        # it's private :(
        # this seems slightly less awful than a class_eval?
        base.send(:handle_exception, HANDLER_MAP)
      end

      private

      def handle_not_found(exception)
        # Returns a rack array
        resp = Watashi::Controllers::Errors::NotFound.new.call({})
        status 404, resp.last.join
      end

    end
  end
end
