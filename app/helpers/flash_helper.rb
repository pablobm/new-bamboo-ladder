module FlashHelper

  def render_flash
    return unless flash.key?(:display)

    messages = flash[:display].collect do |msg, opts|
      begin
        flash_class = (msg.to_s.camelize + "Flash").constantize
        f = flash_class.new(opts)
        render f.template, f.locals
      rescue User
        raise "I don't know what to do with #{msg.inspect}"
      end
    end

    content_tag(:div, messages.join.html_safe, id: 'flash')
  end

  def player(name)
    content_tag(:strong, name, class: 'player')
  end


  private

  def flash_result(opts)
    result_id = opts.fetch(:result_id)
    result = Result.find(result_id)
    render 'flash/result', result: result
  end
end
