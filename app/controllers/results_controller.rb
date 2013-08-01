class ResultsController < ApplicationController
  def index
    @results = Result.latest_first
  end

  def create
    result = Result.create!(result_params)
    ladder.resolve(result)
    redirect_to :back, notice: MessagePresenter.new_result_summary(result)
  end


  private

  def result_params
    params.require(:result).permit(:winner_id, :loser_id)
  end

  def ladder
    @ladder ||= Ladder.instance
  end
end
