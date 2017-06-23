module Watashi
  module Controllers
    class StaticController < AbstractController

      ASSET_PATH = File.join(Watashi::BASE_DIR, "web", "assets").freeze

      def get
        asset_file = File.join(ASSET_PATH, @captures[:name])

        if File.exist?(asset_file)
          mime = Watashi::Mime.detect_from_path(asset_file)
          asset_body = File.read(asset_file)

          respond(body: asset_body, headers: {"Content-Type" => mime})
        else
          respond_error(:not_found)
        end
      end

    end
  end
end
