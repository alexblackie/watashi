module Watashi

  LegacyRouter = Watashi::Application.new(
    route_map: Watashi::ROUTES,
    base_dir: Watashi::BASE_DIR
  )

  Router = Hanami::Router.new do
    get "/", to: Watashi::Controllers::Root::Index
    get "/rss.xml", to: Watashi::Controllers::Rss::Index

    # TODO: remove regex constraint once legacy app is gone.
    get "/:id", id: /(about|dpi)$/, to: Watashi::Controllers::Pages::Show

    # Fallback: if no route matches, try the legacy app.
    get "/*", to: Watashi::LegacyRouter
  end

end
