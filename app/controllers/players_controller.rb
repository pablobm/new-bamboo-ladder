class PlayersController < ApplicationController
  def index
    @players = User.in_order
  end
end
