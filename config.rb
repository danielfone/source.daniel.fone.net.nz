set :layout, :page
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

Time.zone = "Wellington"

###
# Blog settings
###

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "blog"

  blog.permalink = "{year}/{month}/{day}/{title}"
  # Matcher for blog source files
  blog.sources = "{year}/{year}-{month}-{day}-{title}"
  # blog.taglink = "tags/{tag}.html"
  blog.layout = 'post'
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:

page "/feed.xml", layout: false

###
# Helpers
###

activate :directory_indexes

# Methods defined in the helpers block are available in templates
helpers do
  def format_date(date)
    date.strftime('%e %b, %Y')
  end

  def comments_enabled?
    current_article.metadata[:page]['comments'] != false
  end

end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
