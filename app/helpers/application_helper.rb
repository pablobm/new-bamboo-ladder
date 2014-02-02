module ApplicationHelper
  def current_if_section(hsh)
    current_page?(hsh) ? 'is-current' : ''
  end

  def link_to_settings
    link_to settings_path do
      content_tag(:span, "Settings", class: 'text') +
        content_tag(:i, '', class: 'fa fa-cog')
    end
  end
end
