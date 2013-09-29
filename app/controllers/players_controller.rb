class PlayersController < ApplicationController
  def index
    @players = ListedPlayer.all
  end
end
