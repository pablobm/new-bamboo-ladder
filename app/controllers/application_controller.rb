class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    auth && auth.user
  end
  helper_method :current_user


  protected

  def auth
    @auth ||= Auth.load(session[:auth])
  end

end
