module PlayersHelper
  def players_as_options
    ['---'] + Player.active.alphabetical.map{|e| [e.name, e.id] }
  end

  def sparkline_data_for(player)
    recorded_values = player.results.in_order.last(50).map(&:previous_state).map{|state| state['elo_ratings'].fetch(player.id){ nil } }
    values = recorded_values + [player.elo_rating]
    values.map{|v| v ? v - sparkline_central_value : 0 }.join(',')
  end

  def sparkline_max
    [min_elo_value, max_elo_value].map(&:abs).max
  end

  def sparkline_min
    -sparkline_max
  end

  def sparkline_central_value
    @sparkline_central_value ||= EloRating.instance.initial_rating
  end

  private

  def min_elo_value
    min = Result.all.map{|r| r.previous_state.fetch('elo_ratings'){ {} }.values.compact.min || sparkline_central_value }.min
    min ? min - sparkline_central_value : sparkline_central_value
  end

  def max_elo_value
    max = Result.all.map{|r| r.previous_state.fetch('elo_ratings'){ {} }.values.compact.max || sparkline_central_value }.max
    max ? max - sparkline_central_value : sparkline_central_value
  end
end
