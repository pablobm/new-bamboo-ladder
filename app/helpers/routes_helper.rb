module RoutesHelper
  def login_path
    if Rails.configuration.developer_auth
      '/auth/developer'
    else
      '/auth/google_oauth2'
    end
  end
end
