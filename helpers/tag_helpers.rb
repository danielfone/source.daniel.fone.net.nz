module TagHelpers
  def format_date(date)
    date.strftime('%e %b, %Y')
  end

  def nav_link_to(link_text, url, options = {})
    options[:class] ||= ""
    options[:class] << ' blog-nav-item'
    options[:class] << " active" if url == current_page.url
    link_to link_text, url, options
  end

  def page_title
    [current_page.data.title, 'Daniel Fone'].compact.join ' - '
  end
end