module PlayersHelper
  def players_as_options
    ['---'] + User.all.map{|u| [u.name, u.id] }
  end
end
