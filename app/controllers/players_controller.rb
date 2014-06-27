class PlayersController < ApplicationController
  before_action :authenticate, only: [:create, :new, :show, :destroy]
  respond_to :html

  def index
    @players = Player.active.in_elo_order
  end

  def create
    @player = Player.create(create_params.merge(elo_rating: EloRating.instance.initial_rating))
    recalculate_positions
    respond_with @player, location: players_path
  end

  def show
    @player = Player.find(params[:id])
    respond_with @player
  end

  def destroy
    @player = Player.find(params[:id])
    @player.remove
    recalculate_positions
    redirect_to root_path, notice: "#{@player.name} has been removed"
  end

  private

  def create_params
    params.require(:player).permit(:name)
  end

  def recalculate_positions
    EloRating.instance.recalculate_positions
  end
end
