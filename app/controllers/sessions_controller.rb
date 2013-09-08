class SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token, only: :create

  def create
    session[:auth] = Auth.from_auth_hash(auth_hash).dump
    flash[:notice] = "Welcome #{current_user.email}"
  rescue Auth::InvalidUser
    flash[:alert] = "Sorry, only addresses @new-bamboo are allowed"
  ensure
    redirect_to root_path
  end


  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
