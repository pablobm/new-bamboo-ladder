module ApplicationHelper
  def current_if_section(section)
    section == controller.controller_name ? 'is-current' : ''
  end

  def ordinal_position(player)
    ordinal(player.position + 1)
  end

  def ordinal(integer)
    case integer % 10
    when 1
      "#{integer}st"
    when 2
      "#{integer}nd"
    when 3
      "#{integer}rd"
    else
      "#{integer}th"
    end
  end
end
