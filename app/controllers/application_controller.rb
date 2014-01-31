class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :prepare_new_result_form


  protected

  def trusted_user?
    Figaro.env.trusted_ips.split(',').include?(request.remote_ip)
  end
  helper_method :trusted_user?

  def prepare_new_result_form
    @result = Result.new
  end

  def display_message_now(mtype, opts = {})
    @flash_now ||= {}
    @flash_now[:messages] ||= []
    @flash_now[:messages] << opts.merge({_type_: mtype})
  end

  def display_message(mtype, opts = {})
    unless mtype.kind_of?(Symbol)
      raise ArgumentError, "Messages type should be a Symbol (got #{mtype.inspect})"
    end
    flash[:messages] ||= []
    flash[:messages] << opts.merge({_type_: mtype})
  end

  def authenticate
    render text: "These aren't the droids you're looking for...", status: :forbidden unless trusted_user?
  end

end
