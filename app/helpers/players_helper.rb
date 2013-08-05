module PlayersHelper
  def players_as_options
    ['---'] + User.in_order.map{|u| [u.name, u.id] }
  end
end
