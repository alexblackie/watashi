# frozen_string_literal: true

module Watashi
  BASE_DIR = File.join(File.dirname(__FILE__), "..", "..").freeze

  ROUTES = {
    %r{^/assets/(?<name>.+)$} => { class: "Yokunai::StaticController", methods: ["GET"] },

    %r{^/articles/(?<slug>.+)$} => { class: "Watashi::Controllers::ArticlesController", methods: ["GET"] },

    %r{^/albums/?$} => { class: "Watashi::Controllers::AlbumsController", methods: ["GET"] },
    %r{^/albums/(?<album_id>[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/(?<id>[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/?$} => { class: "Watashi::Controllers::PhotoSetController", methods: ["GET"] },
  }.freeze
end
