# frozen_string_literal: true

require "yaml"

require "hanami/assets"
require "hanami/router"
require "hanami/controller"
require "hanami/view"

require "watashi/constants"
require "watashi/errors"

require "watashi/domain/article"
require "watashi/domain/album"
require "watashi/domain/photo_set"
require "watashi/domain/page"
require "watashi/services/data_bag"

require "watashi/controllers/handle_errors"
require "watashi/controllers/errors/not_found"
require "watashi/controllers/root/index"
require "watashi/controllers/rss/index"
require "watashi/controllers/pages/show"
require "watashi/controllers/articles/show"
require "watashi/controllers/photo_sets/index"
require "watashi/controllers/photo_sets/show"

require_relative "../config/hanami"
require_relative "../config/assets"

require "watashi/views/site_layout"
require "watashi/views/root/index"
require "watashi/views/rss/index"
require "watashi/views/pages/show"
require "watashi/views/articles/show"
require "watashi/views/photo_sets/index"
require "watashi/views/photo_sets/show"

require "watashi/router"
