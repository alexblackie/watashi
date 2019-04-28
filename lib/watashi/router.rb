# frozen_string_literal: true

module Watashi
  LegacyRouter = Yokunai::Application.new(
    route_map: Watashi::ROUTES,
    base_dir: Watashi::BASE_DIR
  )

  Router = Hanami::Router.new do
    get "/", to: Watashi::Controllers::Root::Index
    get "/rss.xml", to: Watashi::Controllers::Rss::Index

    get "/articles/:id", to: Watashi::Controllers::Articles::Show

    get "/albums", to: Watashi::Controllers::PhotoSets::Index
    get "/albums/:album_id/:id", to: Watashi::Controllers::PhotoSets::Show

    # TODO: remove regex constraint once legacy app is gone.
    get "/:id", id: /(about|dpi)$/, to: Watashi::Controllers::Pages::Show

    # Maintain `*.shtml` redirects from very legacy site
    get "/:id.shtml", to: ->(env) { [301, {"Location" => "/#{ env["router.params"][:id] }"}, []] }

    # Fallback: if no route matches, try the legacy app.
    get "/*", to: Watashi::LegacyRouter
  end
end
