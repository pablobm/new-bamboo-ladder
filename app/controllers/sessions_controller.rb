class SessionsController < ApplicationController
  def create
    @current_user = Auth.from_auth_hash(auth_hash).user
    redirect_to root_path
  end


  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
