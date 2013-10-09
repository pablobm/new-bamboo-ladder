class Player < ActiveRecord::Base

  validates :name, presence: true


  def self.in_elo_order
    self.where('elo_rating IS NOT NULL').order('elo_rating DESC')
  end

  def self.alphabetical
    self.order('name ASC')
  end


end
