class ResultsController < ApplicationController

  def index
    @results = Result.latest_first
  end

  def create
    result = NewResult.create!(create_params)
    #display_message(:result, result_id: result.id)
    redirect_to :back
  end

  def undo
    @result = Result.latest_first.first
  end

  def destroy
    DiscardedResult.find(params[:id]).destroy
    redirect_to root_path, notice: "OK, let's pretend that didn't happen"
  end


  private

  def create_params
    params.require(:result).permit(:winner_id, :loser_id)
  end

end
