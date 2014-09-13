# =============================================================================
# Blog settings
# =============================================================================
Time.zone = 'America/Vancouver'

activate :blog do |blog|
  blog.permalink         = 'articles/{title}'
  blog.sources           = 'articles/{year}-{month}-{day}-{title}'
  blog.default_extension = '.md'
  blog.layout            = 'article'
  blog.paginate          = true
  blog.per_page          = 10
  blog.page_link         = 'page/{num}'
end

page '/feed.xml', layout: false


# =============================================================================
# Extensions/Features
# =============================================================================
activate :automatic_image_sizes


# =============================================================================
# Compass
# =============================================================================
set :css_dir,    'stylesheets'
set :js_dir,     'javascripts'
set :images_dir, 'images'


# =============================================================================
# Build configuration
# =============================================================================
configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :relative_assets
end
