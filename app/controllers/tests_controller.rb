class TestsController < ApplicationController

  def show
    flash.now[:display] = {result: {result_id: Result.last.id}}
    flash.now[:notice] = "This is a simple notice"
  end


end
