# frozen_string_literal: true

# \ -s puma
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
require "watashi"

use Rack::Static, :urls => ["/assets"], root: "public"

run Watashi::Router
