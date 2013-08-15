class User < ActiveRecord::Base
  validates :google_uid, uniqueness: true, allow_nil: true
  validates :email, presence: true, uniqueness: true, format: {with: %r{@new-bamboo\.co\.uk\z}i}
end
