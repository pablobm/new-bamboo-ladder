module FlashHelper

  def render_flash
    messages = flash_complex_messages
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
      f = ResultFlash.new(msg)
      render f.template, f.locals
    end.join
  end

end
