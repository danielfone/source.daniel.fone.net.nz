module BlogHelpers

  def recent_articles
    blog.articles[0...5]
  end

  # Grab the most recent featured article and two other random ones
  def featured_articles
    features =
      blog
      .articles
      .select { |a| a.data[:featured] }
      .reject { |a| a == current_article }
      .sort_by { |a| a.date }

    [features.pop, *features.sample(2)]
  end

  def reading_time(input)
    words_per_minute = 200

    words = input.split.size
    minutes = (words/words_per_minute).floor
    minutes_label = minutes === 1 ? ' minute' : ' minutes'
    minutes > 0 ? "about #{minutes} #{minutes_label}" : 'less than 1 minute'
  end

end
