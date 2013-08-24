module FlashHelper

  def render_flash
    return unless flash.key?(:display)

    messages = flash[:display].collect do |msg, locals|
      flash_method = "flash_#{msg}"
      if respond_to?(flash_method)
        send(flash_method, locals)
      else
        raise "I don't know what to do with #{msg.inspect}"
      end
    end

    content_tag(:div, messages.join.html_safe, id: 'flash')
  end

  def flash_result(opts)
    result_id = opts.fetch(:result_id)
    result = Result.find(result_id)
    render 'flash/result', result: result
  end
end
