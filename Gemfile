# frozen_string_literal: true

source "https://rubygems.org/"

# Hanami is wonderfully modular, so we only need to pull in a couple core
# pieces to get a really minimal but beautiful web framework
gem "hanami-controller"
gem "hanami-router"
gem "hanami-view"

# Kept around to run both apps in parallel until we move everything over to the
# new Hanami stack.
gem "yokunai"

gem "puma"

group :development, :test do
  gem "pry"
  gem "rspec"
  gem "rubocop", require: false
end

group :test do
  gem "rack-test"
end
