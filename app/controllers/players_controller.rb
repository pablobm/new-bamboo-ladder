class PlayersController < ApplicationController
  def index
    @players = Player.in_elo_order
  end
end
