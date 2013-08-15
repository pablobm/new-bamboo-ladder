class EloRating
  include Singleton

  def resolve(result)
    Player.transaction do
      loser = result.loser
      winner = result.winner
      l = Elo::Player.new(rating: loser.elo_rating)
      w = Elo::Player.new(rating: winner.elo_rating)
      w.wins_from(l)
      loser.elo_rating = l.rating
      loser.save!
      winner.elo_rating = w.rating
      winner.save!
    end
  end
end
