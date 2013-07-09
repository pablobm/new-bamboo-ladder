require 'omniauth'

module OmniAuth
  module Strategies
    class Developer
      include OmniAuth::Strategy

      option :fields, [:email]
      option :uid_field, :email

      def request_phase
        form = OmniAuth::Form.new(title: "Fake user info", url: callback_path)
        options.fields.each do |field|
          form.text_field field.to_s.capitalize.gsub('_', ' '), field.to_s
        end
        form.button 'Log in'
        form.to_response
      end

      uid do
        request.params[options.uid_field.to_s]
      end

      info do
        info = options.fields.inject({}) do |hash, field|
          hash[field] = request.params[field.to_s]
          hash
        end
        info[:first_name] = info[:email].split('@').first.capitalize
        info
      end

    end
  end
end
