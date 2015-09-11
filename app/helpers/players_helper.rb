module PlayersHelper
  def players_as_options
    ['---'] + Player.alphabetical.map{|e| [e.name, e.id] }
  end

  def sparkline_data_for(player)
    sparkline_scores_by_user.fetch(player.id, [player.elo_rating]).map{|v| v ? v - sparkline_central_value : 0 }.join(',')
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

  def sparkline_results
    Result.where('created_at > ?', 6.months.ago).in_order
  end

  def sparkline_scores_by_user
    @sparkline_scores_by_user ||= sparkline_results.each_with_object({}) do |result, memo|
      memo[result.winner_id] ||= []
      memo[result.loser_id] ||= []
      memo[result.winner_id] << result.winner_current_score
      memo[result.loser_id] << result.loser_current_score
    end
  end

  def min_elo_value
    min = sparkline_results.minimum(:loser_current_score)
    min ? min - sparkline_central_value : sparkline_central_value
  end

  def max_elo_value
    max = sparkline_results.maximum(:winner_current_score)
    max ? max - sparkline_central_value : sparkline_central_value
  end

end
