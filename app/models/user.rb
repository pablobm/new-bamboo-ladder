class User < ActiveRecord::Base
  validates :google_uid, presence: true
  validates :email, presence: true
  validates :name, presence: true
end
