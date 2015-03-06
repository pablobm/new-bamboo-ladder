class EloRating
  include Singleton

  def resolve(winner_id, loser_id)
    now = Time.zone.now
    if first_result_of_week?(now)
      decay(now)
    end

    previous_state = State.dump

    points = nil

    Player.transaction do
      winner = Player.find_by_id!(winner_id)
      loser = Player.find_by_id!(loser_id)
      points = update_player_scores(winner, loser)
      Result.create!(winner_id: winner_id, loser_id: loser_id, previous_state: previous_state)
    end

    points
  end

  def resolve_with_result(result)
    if first_result_of_week?(result.created_at)
      decay(result.created_at)
    end

    previous_state = State.dump

    points = nil

    Player.transaction do
      points = update_player_scores(result.winner, result.loser)
      result.update_attributes!(previous_state: previous_state)
    end

    points
  end

  def resolve_from(result)
    Player.transaction do
      state = State.load(result.previous_state)
      state.players.each do |p|
        Player.find(p.id).update_attributes!({
          elo_rating: p.elo_rating,
        })
      end
      Result.where('id >= ?', result.id).order('id ASC').each do |r|
        resolve_with_result(r)
      end
    end
  end

  def initial_rating
    @initial_rating ||= Elo::Player.new.rating
  end

  private

  INACTION_LIMIT = 4.weeks

  def first_result_of_week?(now)
    previous = Result.in_order.where('created_at < ?', now).last or return true
    week_for_previous = previous.created_at.to_date.cweek
    week_for_current = now.to_date.cweek
    week_for_previous != week_for_current
  end

  def dormancy_threshold
    Time.now - INACTION_LIMIT
  end

  def update_player_scores(winner, loser)
    points_transfered = nil

    ensure_rating(loser)
    ensure_rating(winner)
    l = Elo::Player.new(rating: loser.elo_rating)
    w = Elo::Player.new(rating: winner.elo_rating)
    w.wins_from(l)
    points_transfered = loser.elo_rating - l.rating
    loser.elo_rating -= points_transfered
    loser.save!
    winner.elo_rating += points_transfered
    winner.save!

    points_transfered
  end

  def decay(time)
    ever_played_ids = Result.where('created_at < ?', time).participant_ids
    inactive_ids = Player.pluck(:id) - ever_played_ids
    active_ids = Result.where('? < created_at AND created_at < ?', dormancy_threshold, time).participant_ids
    dormant_ids = Player.where('id NOT IN (?)', active_ids).pluck(:id) - inactive_ids
    if Result.where('created_at < ?', dormancy_threshold).exists? && dormant_ids.any?
      Player.where('id IN (?)', active_ids).update_all("elo_rating = elo_rating + #{dormant_ids.count.to_i}")
      Player.where('id IN (?)', dormant_ids).update_all("elo_rating = elo_rating - #{active_ids.count.to_i}")
    end
  end

  def ensure_rating(player)
    player.elo_rating = initial_rating if player.elo_rating.nil?
  end

end
