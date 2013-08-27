class TestsController < ApplicationController

  def show
    flash.now[:display] = {result: {result_id: Result.last.id}}
  end


end
