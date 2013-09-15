class Player < ActiveRecord::Base

  validates :name, presence: true
  validates :ladder_rank, uniqueness: true

  before_validation :reset_ladder_rank, on: :create

  def self.in_ladder_order
    Player.order('ladder_rank ASC')
  end

  def self.in_elo_order
    Player.order('elo_rating ASC')
  end

  def self.alphabetical
    Player.order('name ASC')
  end


  protected

  def reset_ladder_rank
    last_rank = Player.order('ladder_rank DESC').limit(1).select(:ladder_rank).first.try(:ladder_rank) || 0
    self.ladder_rank ||= last_rank + 1
  end

end
