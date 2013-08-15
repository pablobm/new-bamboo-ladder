class PlayersController < ApplicationController
  def index
    @players = Player.in_order
  end
end
