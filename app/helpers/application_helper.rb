module ApplicationHelper
  def current_if_section(section)
    section == controller.controller_name ? 'is-current' : ''
  end
end
