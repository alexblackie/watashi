# frozen_string_literal: true

# \ -s puma
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
require "watashi"

legacy_app = Watashi::Application.new(
  route_map: Watashi::ROUTES,
  base_dir: Watashi::BASE_DIR
)

router = Hanami::Router.new do
  get "/", to: Watashi::Controllers::Root::Index

  # Fallback: if no route matches, try the legacy app.
  get "/*", to: legacy_app
end

run router
