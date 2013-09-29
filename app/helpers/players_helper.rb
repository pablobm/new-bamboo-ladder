module PlayersHelper
  def players_as_options
    ['---'] + Player.in_elo_order.map{|e| [e.name, e.id] }
  end
end
