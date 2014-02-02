class SettingsController < ApplicationController

  def index
    @player = Player.new(params[:player])
  end

end
