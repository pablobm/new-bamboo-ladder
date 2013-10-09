module PlayersHelper
  def players_as_options
    ['---'] + Player.alphabetical.map{|e| [e.name, e.id] }
  end
end
