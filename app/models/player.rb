class Player < ActiveRecord::Base

  validates :name, presence: true


  def self.in_elo_order
    self.where('elo_rating IS NOT NULL').order('elo_rating DESC')
  end


end
