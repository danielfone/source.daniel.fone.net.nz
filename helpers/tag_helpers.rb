module TagHelpers
  def monthly_header(date)
    date_string = format_date date
    return if date_string == @prev_date_string
    yield date_string
    @prev_date_string = date_string
  end

  def format_date(date)
    date.strftime('%B %Y')
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