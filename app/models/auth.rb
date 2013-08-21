class Auth

  class InvalidUser < StandardError; end

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
      })

    new(user)
  rescue ActiveRecord::RecordInvalid
    raise Auth::InvalidUser, "Can't recognise auth hash #{auth_hash.inspect}"
  end

  def self.load(dump)
    user = User.find_by_id(dump[:user_id]) if dump
    new(user)
  end

  def dump
    user ? {user_id: user.id} : {}
  end

end
