class ResultsController < ApplicationController
  def index
    @results = Result.all
  end

  def create
    @result = Result.create(result_params)
    redirect_to :back
  end


  private

  def result_params
    params.require(:result).permit(:winner_id, :loser_id)
  end
end
