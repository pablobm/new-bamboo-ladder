class User < ActiveRecord::Base
  validates :google_uid, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: {with: %r{@new-bamboo\.co\.uk\z}i}
  validates :name, presence: true
  validates :position, uniqueness: true

  before_validation :reset_position, on: :create

  def self.in_order
    User.order('position')
  end

  protected

  def reset_position
    last_position = User.order('position DESC').limit(1).select(:position).first.try(:position) || 0
    self.position ||= last_position + 1
  end
end
