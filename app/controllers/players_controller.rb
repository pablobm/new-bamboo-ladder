class PlayersController < ApplicationController
  def index
    @ladder = Player.in_ladder_order
  end
end
