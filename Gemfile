# frozen_string_literal: true

source "https://rubygems.org/"

# Hanami is wonderfully modular, so we only need to pull in a couple core
# pieces to get a really minimal but beautiful web framework
gem "hanami-assets"
gem "hanami-controller"
gem "hanami-router"
gem "hanami-view"

gem "puma"

# TODO: use a maintained library
gem "sass"

group :development, :test do
  gem "pry"
  gem "rspec"
  gem "rubocop", require: false
end

group :development do
  gem "shotgun"
end

group :test do
  gem "rack-test"
end

group :production do
  gem "sentry-raven"
end
