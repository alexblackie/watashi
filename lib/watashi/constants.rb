module Watashi

  BASE_DIR = File.join(File.dirname(__FILE__), "..", "..").freeze

  ROUTES = {
    %r{^/$} => {class: "Watashi::Controllers::RootController", methods: ["GET"]},
    %r{^/assets/(?<name>.+)$} => {class: "Yokunai::StaticController", methods: ["GET"]},
    %r{^/articles/(?<slug>.+)$} => {class: "Watashi::Controllers::ArticlesController", methods: ["GET"]},
    %r{^/(?<slug>.+)$} => {class: "Watashi::Controllers::PagesController", methods: ["GET"]}
  }.freeze

end
