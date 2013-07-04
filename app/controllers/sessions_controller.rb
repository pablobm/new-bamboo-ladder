class SessionsController < ApplicationController
  def create
    session[:auth] = Auth.from_auth_hash(auth_hash).dump
    redirect_to root_path
  end


  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
