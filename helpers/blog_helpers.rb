module BlogHelpers

  def recent_articles
    blog.articles[0...5]
  end

  def featured_articles
    blog.articles.select { |a| a.data[:featured] }.sample(3)
  end

end
