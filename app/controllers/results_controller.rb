class ResultsController < ApplicationController
  def index
    @results = Result.latest_first
  end

  def create
    result = Result.create!(result_params)
    Ladder.instance.resolve(result)
    redirect_to :back
  end


  private

  def result_params
    params.require(:result).permit(:winner_id, :loser_id)
  end
end
