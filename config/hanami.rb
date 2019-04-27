# frozen_string_literal: true

Hanami::View.configure do
  layout "watashi/views/site"
  root File.join(__dir__, "..", "web", "templates")
end

Hanami::Controller.configure do
  default_request_format :html
  default_response_format :html
end

Hanami::View.load!
