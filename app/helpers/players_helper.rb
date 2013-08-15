module PlayersHelper
  def players_as_options
    ['---'] + Player.in_order.map{|e| [e.name, e.id] }
  end
end
