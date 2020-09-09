module TagHelpers
  def format_date(date)
    date.strftime('%B %Y')
  end

  def nav_link_to(link_text, url, options = {})
    options[:class] = Array(options[:class])
    options[:class] << "active" if url == current_page.url
    link_to link_text, url, options
  end

  def page_title
    [current_page.data.title, 'Daniel Fone'].compact.join ' - '
  end

  def link_to_self(url)
    link_to url, url
  end

  def avatar_img_tag(size=70)
    image_tag "//www.gravatar.com/avatar/5efc2a040a61cb22107bcfcecd58454c.jpg?s=#{size * 2}",
      width: size,
      class: 'avatar'
  end
end
