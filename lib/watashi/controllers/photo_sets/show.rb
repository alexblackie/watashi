module Watashi
  module Controllers
    module PhotoSets
      class Show

        include Hanami::Action
        include Watashi::Controllers::HandleErrors

        def call(params)
          album = Watashi::Services::DataBag
                  .new(model: Watashi::Domain::Album).one(params[:album_id])
          photo_set = Watashi::Services::DataBag
                      .new(model: Watashi::Domain::PhotoSet).one(params[:id])

          ctx = {
            format: :html,
            album: album,
            photo_set: photo_set
          }

          self.body = Watashi::Views::PhotoSets::Show.render(ctx)
        end

      end
    end
  end
end
