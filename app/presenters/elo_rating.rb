class EloRating
  include Singleton

  def resolve(result)
    if first_result_of_week?(result)
      decay(result.created_at)
    end
    update_players(result.winner, result.loser)
  end

  def undo(result)
    Player.transaction do
      result.previous_state.players.each do |p|
        Player.find(p.id).update_attributes!({
          position: p.position,
          elo_rating: p.elo_rating,
        })
      end
      Result.where('id > ?', result.id).order('id ASC').each do |r|
        resolve(r)
      end
    end
  end

  def initial_rating
    @initial_rating ||= Elo::Player.new.rating
  end

  def recalculate_positions
    Player.transaction do
      last_rating = nil
      last_position = nil
      Player.active.in_elo_order.each_with_index do |player, i|
        expected_position = i+1
        if player.elo_rating
          position = (last_rating == player.elo_rating) ? last_position : expected_position
        else
          position = nil
        end
        last_rating = player.elo_rating
        last_position = position
        player.update_attributes(position: position)
      end
    end
  end


  private

  INACTION_LIMIT = 4.weeks

  def first_result_of_week?(result)
    previous = Result.in_order.where('id < ?', result.id).last or return true
    week_for_previous = previous.created_at.to_date.cweek
    week_for_current = result.created_at.to_date.cweek
    week_for_previous != week_for_current
  end

  def dormancy_threshold
    Time.now - INACTION_LIMIT
  end

  def update_players(winner, loser)
    diff = nil
    Player.transaction do
      ensure_rating(loser)
      ensure_rating(winner)
      l = Elo::Player.new(rating: loser.elo_rating)
      w = Elo::Player.new(rating: winner.elo_rating)
      w.wins_from(l)
      diff = loser.elo_rating - l.rating
      loser.elo_rating -= diff
      loser.save!
      winner.elo_rating += diff
      winner.save!

      recalculate_positions
    end
    diff
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
