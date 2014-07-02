class Player < ActiveRecord::Base

  has_many :won_results, class_name: 'Result', foreign_key: 'winner_id'
  has_many :lost_results, class_name: 'Result', foreign_key: 'loser_id'

  scope :active, -> { where(removed_at: nil) }

  validates :name, presence: true, uniqueness: { case_sensitive: false }


  def self.in_elo_order
    self.where('elo_rating IS NOT NULL').order('elo_rating DESC')
  end

  def self.alphabetical
    self.order('name ASC')
  end

  def results
    Result.where('winner_id = ? OR loser_id = ?', self.id, self.id).in_order
  end

  def active
    removed_at.nil?
  end

  def remove
    self.update_attributes removed_at: Time.now, position: nil
  end

end
