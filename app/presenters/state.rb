class State

  def self.dump
    elo_ratings = Player.all.inject({}) do |memo, p|
      memo[p.id] = p.elo_rating
      memo
    end
    {elo_ratings: elo_ratings}
  end

end
