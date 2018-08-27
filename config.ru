#\ -s puma
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
require "elastic_apm"
require "watashi"

use ElasticAPM::Middleware

app =  Watashi::Application.new(
  route_map: Watashi::ROUTES,
  base_dir: Watashi::BASE_DIR
)

ElasticAPM.start(app: app)

run app

at_exit { ElasticAPM.stop }
