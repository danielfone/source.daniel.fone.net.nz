module CommentsHelper

  def comments_enabled?
    current_article.metadata[:page]['comments'] != false
  end

  def disqus_identifier
    'http://daniel.fone.net.nz'+url_for(current_page)
  end

end
