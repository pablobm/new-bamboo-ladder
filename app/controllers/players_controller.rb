class PlayersController < ApplicationController
  before_action :authenticate, only: :create

  def index
    @players = Player.in_elo_order
  end

  def create
    @player = Player.create(create_params.merge(elo_rating: EloRating.instance.initial_rating))
    redirect_to players_path
  end

  private

  def create_params
    params.require(:player).permit(:name)
  end
end
