class PlayersController < ApplicationController
  def index
    @players = Player.in_elo_order.each_with_index.map{|p, i| PlayerPresenter.new(p, i) }
  end
end
