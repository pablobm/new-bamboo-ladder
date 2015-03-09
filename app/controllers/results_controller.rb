class ResultsController < ApplicationController
  before_action :authenticate, only: [:create, :undo, :destroy]

  def index
    @results = Result.latest_first.page(params[:page]).per(params[:per_page])
  end

  def create
    points = EloRating.instance.resolve(params[:result][:winner_id], params[:result][:loser_id])
    display_message(winner_id: params[:result][:winner_id], loser_id: params[:result][:loser_id], points: points)
    redirect_to :back
  end

  def undo
    @result = Result.latest_first.first
  end

  def destroy
    DiscardedResult.destroy(params[:id])
    redirect_to root_path, notice: "OK, let's pretend that didn't happen"
  end

end
