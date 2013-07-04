class RemoteIdentity

  def self.new_from_auth_hash(auth_hash)
    case auth_hash['provider']
    when 'developer'
      Developer.new(auth_hash)
    when 'github'
      Github.new(auth_hash)
    when 'browser_id'
      BrowserId.new(auth_hash)
    when 'google_oauth2'
      GoogleOauth2.new(auth_hash)
    when 'twitter'
      Twitter.new(auth_hash)
    else
      raise "I can't read the auth hash #{auth_hash.to_hash.inspect}"
    end
  end


  private

  class Base
    attr_reader :uid, :info, :hash

    def provider
      self.class.name.underscore.split('/').last
    end

    def initialize(auth_hash)
      @hash = auth_hash
      @uid = @hash['uid']

      info = @hash['info']
      @info = {
        provider: provider,
        uid: uid,
        email: info['email'],
        screen_name: info['name']
      }
    end
  end

  class Developer < Base
    def initialize(auth_hash)
      super(auth_hash)
      @info[:screen_name] = auth_hash['info']['screen_name']
    end
  end

  class Github < Base
    def initialize(auth_hash)
      super(auth_hash)
      @info[:screen_name] = auth_hash['info']['nickname']
    end
  end

  class BrowserId < Base; end

  class GoogleOauth2 < Base; end

  class Twitter < Base
    def initialize(auth_hash)
      super(auth_hash)
      @info[:screen_name] = auth_hash['info']['nickname']
    end
  end


end
