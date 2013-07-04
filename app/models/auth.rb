class Auth

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def self.from_auth_hash(auth_hash)
    ri = RemoteIdentity.new_from_auth_hash(auth_hash)
    user =
      User.find_by_google_uid(ri.uid) ||
      User.create!({
        google_uid: ri.uid,
        email: ri.info[:email],
        name: ri.hash['info']['first_name'],
      })

    new(user)
  end

end
