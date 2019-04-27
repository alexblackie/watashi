# frozen_string_literal: true

require "hanami/router"
require "hanami/controller"
require "hanami/view"

require "yokunai"

require_relative "../config/hanami"

require "watashi/constants"
require "watashi/application"
require "watashi/domain/article"
require "watashi/domain/album"
require "watashi/domain/photo_set"
require "watashi/domain/page"
require "watashi/services/data_bag"

require "watashi/controllers/root/index"

require "watashi/views/site_layout"
require "watashi/views/root/index"

require "watashi/controllers/articles_controller"
require "watashi/controllers/pages_controller"
require "watashi/controllers/albums_controller"
require "watashi/controllers/photo_set_controller"
require "watashi/controllers/feed_controller"
