class Player < ActiveRecord::Base

  validates :name, presence: true


  def self.in_elo_order
    self.where('elo_rating IS NOT NULL').order('elo_rating DESC')
  end

  def self.alphabetical
    self.order('name ASC')
  end

  def results
    Result.where('winner_id = ? OR loser_id = ?', self.id, self.id).in_order
  end


end
