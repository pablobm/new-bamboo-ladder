class HomesController < ApplicationController
  def show
    redirect_to players_path
  end
end
