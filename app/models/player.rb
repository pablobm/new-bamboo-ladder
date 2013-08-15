class Player < ActiveRecord::Base

  validates :name, presence: true
  validates :position, uniqueness: true

  before_validation :reset_position, on: :create

  def self.in_order
    Player.order('position ASC')
  end

  protected

  def reset_position
    last_position = Player.order('position DESC').limit(1).select(:position).first.try(:position) || 0
    self.position ||= last_position + 1
  end

end
