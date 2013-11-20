#-----------------------------------------------------------------------------
# Vendor Deps
#-----------------------------------------------------------------------------
require 'susy'


#-----------------------------------------------------------------------------
# Features: ACTIVATE!
#-----------------------------------------------------------------------------
activate :automatic_image_sizes


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
