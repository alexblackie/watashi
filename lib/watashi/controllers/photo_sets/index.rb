module Watashi
  module Controllers
    module PhotoSets
      class Index

        include Hanami::Action

        def call(params)
          service = Watashi::Services::DataBag.new(model: Watashi::Domain::Album)

          ctx = {
            format: :html,
            albums: service.all
          }

          self.body = Watashi::Views::PhotoSets::Index.render(ctx)
        end

      end
    end
  end
end
