#-----------------------------------------------------------------------------
# Vendor Deps
#-----------------------------------------------------------------------------
require 'susy'


#-----------------------------------------------------------------------------
# Features: ACTIVATE!
#-----------------------------------------------------------------------------
activate :automatic_image_sizes


#-----------------------------------------------------------------------------
# Deploy to Cloudfront via middleman-sync
#-----------------------------------------------------------------------------
activate :sync do |sync|
  sync.fog_provider          = 'AWS'
  sync.fog_directory         = ENV['AWS_BUCKET']
  sync.fog_region            = 'us-west-2'
  sync.aws_access_key_id     = ENV['AWS_ACCESS']
  sync.aws_secret_access_key = ENV['AWS_SECRET']
  sync.existing_remote_files = 'keep'
  sync.gzip_compression      = true
  sync.after_build           = false
end


#-----------------------------------------------------------------------------
# Blog
#-----------------------------------------------------------------------------
activate :blog do |blog|
  blog.prefix            = 'articles'
  blog.permalink         = ':title.html'
  blog.sources           = ':year-:month-:day-:title.html'
  blog.taglink           = 'topics/:tag.html'
  blog.layout            = 'article-layout'
  blog.year_link         = ':year.html'
  blog.month_link        = ':year/:month.html'
  blog.day_link          = ':year/:month/:day.html'
  blog.default_extension = '.md'

  blog.tag_template      = 'tag.html'
  blog.calendar_template = 'calendar.html'

  blog.paginate  = true
  blog.per_page  = 4
  blog.page_link = 'page/:num'
end

page '/feed.xml', :layout => false


#-----------------------------------------------------------------------------
# Compass
#-----------------------------------------------------------------------------
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'


#-----------------------------------------------------------------------------
# Build Settings
#-----------------------------------------------------------------------------
configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :relative_assets
end
