class User < ActiveRecord::Base
  validates :google_uid, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :position, uniqueness: true

  before_validation :reset_position, on: :create


  protected

  def reset_position
    self.position ||= User.order('position DESC').limit(1).select(:position).first.position + 1
  end
end
