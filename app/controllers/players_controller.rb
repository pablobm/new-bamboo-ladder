class PlayersController < ApplicationController
  def index
    @players = User.all
  end
end
