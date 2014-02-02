class SettingsController < ApplicationController
  before_action :authenticate

  def index
    @player = Player.new(params[:player])
  end

end
