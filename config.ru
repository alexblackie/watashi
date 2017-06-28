#\ -s puma
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
require "watashi"

run Watashi::Application.new
