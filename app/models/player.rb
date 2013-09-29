class Player < ActiveRecord::Base

  validates :name, presence: true
  validates :elo_rating, presence: true


  def self.in_elo_order
    self.order('elo_rating DESC')
  end

end
