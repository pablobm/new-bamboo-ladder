class ResultsController < ApplicationController
  def index
    @results = Result.latest_first
  end

  def create
    result = Result.create!(create_params)
    flash[:display] = { result: {result_id: result.id} }
    redirect_to :back
  end

  def undo
    @result = Result.latest_first.first
  end

  def destroy
    result = Result.find(params[:id])
    result.destroy
    redirect_to root_path, notice: "That result was deleted"
  end


  private

  def create_params
    params.require(:result).permit(:winner_id, :loser_id)
  end

end
