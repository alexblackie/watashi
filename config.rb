set :css_dir,    'stylesheets'
set :js_dir,     'javascripts'
set :images_dir, 'images'

activate :directory_indexes
activate :minify_html

activate :blog do |blog|
  blog.permalink = "{title}"
  blog.sources = "articles/{year}-{month}-{day}-{title}"
  blog.layout = "post"
  blog.default_extension = ".md"
  blog.paginate = true
  blog.per_page = 10
  blog.page_link = "page/{num}"
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :relative_assets
end
