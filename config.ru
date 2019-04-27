#\ -s puma
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
require "watashi"

app =  Watashi::Application.new(
  route_map: Watashi::ROUTES,
  base_dir: Watashi::BASE_DIR
)

run app
