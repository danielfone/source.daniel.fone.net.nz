module BlogHelpers

  def recent_articles
    blog.articles[0...5]
  end

  def featured_articles
    blog.articles.select { |a| a.data[:featured] }.sample(3)
  end

  def reading_time(input)
    words_per_minute = 200

    words = input.split.size
    minutes = (words/words_per_minute).floor
    minutes_label = minutes === 1 ? ' minute' : ' minutes'
    minutes > 0 ? "about #{minutes} #{minutes_label}" : 'less than 1 minute'
  end

end
