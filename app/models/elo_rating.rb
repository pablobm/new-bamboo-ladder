class EloRating
  include Singleton

  def resolve(result)
    if first_result_of_week?(result)
      decay
    end
    update_players(result.winner, result.loser)
    top_up_pool
  end


  private

  INACTION_LIMIT = 4.weeks

  def first_result_of_week?(result)
    previous = Result.in_order.where('id < ?', result.id).last or return true
    week_for_previous = previous.created_at.to_date.cweek
    week_for_current = result.created_at.to_date.cweek
    week_for_previous != week_for_current
  end

  def inaction_threshold
    Time.now - INACTION_LIMIT
  end

  def update_players(winner, loser)
    Player.transaction do
      l = Elo::Player.new(rating: loser.elo_rating)
      w = Elo::Player.new(rating: winner.elo_rating)
      w.wins_from(l)
      loser.elo_rating = l.rating
      loser.save!
      winner.elo_rating = w.rating
      winner.save!
    end
  end

  def decay
    active_ids = Result.where('created_at > ?', inaction_threshold).map{|r| [r.winner_id, r.loser_id] }.flatten.uniq
    inactive_ids = Player.where('id NOT IN (?)', active_ids).map(&:id)
    if Result.where('created_at < ?', inaction_threshold).exists? && inactive_ids.any?
      Player.where('id IN (?)', active_ids).update_all("elo_rating = elo_rating + #{inactive_ids.count.to_i}")
      Player.where('id IN (?)', inactive_ids).update_all("elo_rating = elo_rating - #{active_ids.count.to_i}")
    end
  end


  def top_up_pool
    while Player.count*initial_rating - Player.sum(:elo_rating) > Player.count
      Player.update_all('elo_rating = elo_rating + 1')
    end
  end

  def initial_rating
    @initial_rating ||= Elo::Player.new.rating
  end

end
