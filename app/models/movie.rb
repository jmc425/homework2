class Movie < ActiveRecord::Base
  
  def self.get_distinct_ratings
    distinct_ratings = []
    self.select do |movie| 
      distinct_ratings.push(movie.rating) unless 
        distinct_ratings.include? movie.rating
    end
    return distinct_ratings
  end
end
