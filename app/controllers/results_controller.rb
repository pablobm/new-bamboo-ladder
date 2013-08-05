class ResultsController < ApplicationController
  def index
    @results = Result.latest_first
  end

  def create
    result = Result.create!(result_params)
    notice = MessagePresenter.new_result_summary(result) + render_to_string(inline: %{ <%= link_to "undo", undo_results_path %>})
    redirect_to :back, notice: notice.html_safe
  end

  def undo
    @result = Result.latest_first.first
    pp @result.winner
  end

  def destroy
    result = Result.find(params[:id])
    result.destroy
    redirect_to root_path, notice: "That result was deleted"
  end


  private

  def result_params
    params.require(:result).permit(:winner_id, :loser_id)
  end

end
