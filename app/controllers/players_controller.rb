class PlayersController < ApplicationController
  def index
    @ladder = Player.in_ladder_order
    @elo_ratings = Player.in_elo_order
    @rankings = Player.in_elo_order.each_with_index.map{|p,i| [i+1, p.elo_rating] }
  end
end
