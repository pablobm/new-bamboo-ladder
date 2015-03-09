module PlayersHelper
  def players_as_options
    ['---'] + Player.alphabetical.map{|e| [e.name, e.id] }
  end

  def sparkline_data_for(player)
    last_month_scores_by_user.fetch(player.id, [player.elo_rating]).map{|v| v ? v - sparkline_central_value : 0 }.join(',')
  end

  def sparkline_max
    @sparkline_max ||= [min_elo_value, max_elo_value].map(&:abs).max
  end

  def sparkline_min
    -sparkline_max
  end

  def sparkline_central_value
    @sparkline_central_value ||= EloRating.instance.initial_rating
  end

  private

  def previous_scores
    @previous_scores ||= Result.all.flat_map { |result|
      result.previous_state.fetch('elo_ratings', {}).values.compact
    }
  end

  def last_month_results
    Result.where('created_at > ?', 1.month.ago)
  end

  def last_month_scores_by_user
    @last_month_scores_by_user ||= last_month_results.each_with_object({}) do |result, memo|
      memo[result.winner_id] ||= []
      memo[result.loser_id] ||= []
      memo[result.winner_id] << result.winner_current_score
      memo[result.loser_id] << result.loser_current_score
    end
  end

  def min_elo_value
    min = last_month_results.minimum(:loser_current_score)
    min ? min - sparkline_central_value : sparkline_central_value
  end

  def max_elo_value
    max = last_month_results.maximum(:winner_current_score)
    max ? max - sparkline_central_value : sparkline_central_value
  end

end
