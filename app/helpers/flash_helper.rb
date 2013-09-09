module FlashHelper

  def render_flash
    messages =
      flash_complex_messages +
      flash_simple_messages
    return if messages.empty?

    content_tag(:div, messages.html_safe, id: 'flash')
  end

  def player(name)
    content_tag(:strong, name, class: 'player')
  end


  private

  def flash_complex_messages
    messages = []
    messages += flash[:messages] || []
    messages += @flash_now && @flash_now[:messages] || []
    if messages.empty?
      return ''
    end

    messages.collect do |msg|
      mtype = msg[:_type_]
      begin
        flash_class = (mtype.to_s.camelize + "Flash").constantize
        f = flash_class.new(msg)
        render f.template, f.locals
      rescue User
        raise "I don't know what to do with #{msg.inspect}"
      end
    end.join
  end

  def flash_simple_messages
    [:notice, :alert].map do |k|
      next unless text = flash[k]
      render 'flashes/simple', type: k, text: text
    end.join
  end

  def flash_result(opts)
    result_id = opts.fetch(:result_id)
    result = Result.find(result_id)
    render 'flash/result', result: result
  end
end
