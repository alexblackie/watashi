# frozen_string_literal: true

require "sass"

Hanami::Assets.configure do
  compile true

  sources << [
    "assets",
    "vendor/assets"
  ]
end
