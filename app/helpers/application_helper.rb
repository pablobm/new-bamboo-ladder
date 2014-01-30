module ApplicationHelper
  def current_if_section(hsh)
    current_page?(hsh) ? 'is-current' : ''
  end
end
