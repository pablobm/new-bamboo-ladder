module PlayersHelper
  def players_as_options
    ['---'] + Player.active.alphabetical.map{|e| [e.name, e.id] }
  end

  def sparkline_data_for(player)
    State.rating_history_for(player).map{|v| v ? v - sparkline_central_value : 0 }.join(',')
  end

  def sparkline_max
    State.max_historic_elo_value
  end

  def sparkline_min
    0
  end

  def sparkline_central_value
    @sparkline_central_value ||= EloRating.instance.initial_rating
  end

end
