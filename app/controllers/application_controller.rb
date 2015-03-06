class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :prepare_new_result_form


  protected

  def trusted_user?
    ClientFilter.trusted?(request.remote_ip)
  end
  helper_method :trusted_user?

  def prepare_new_result_form
    @result = Result.new
  end

  def display_message_now(opts = {})
    @flash_now ||= {}
    @flash_now[:messages] ||= []
    @flash_now[:messages] << opts
  end

  def display_message(opts = {})
    flash[:messages] ||= []
    flash[:messages] << opts
  end

  def authenticate
    render text: "These aren't the droids you're looking for...", status: :forbidden unless trusted_user?
  end

end
