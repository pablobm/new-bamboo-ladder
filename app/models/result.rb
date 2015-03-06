class Result < ActiveRecord::Base

  belongs_to :winner, class_name: 'Player'
  belongs_to :loser, class_name: 'Player'

  validates :winner, presence: true
  validates :loser, presence: true
  validates :winner_current_score, presence: true
  validates :loser_current_score, presence: true
  validate :winner_different_from_loser

  before_validation :set_current_scores

  serialize :previous_state, Hash

  def self.in_order
    self.order('created_at ASC, id ASC')
  end

  def self.latest_first
    self.order('created_at DESC, id DESC')
  end

  def self.participant_ids
    all.map{|r| [r.winner_id, r.loser_id] }.flatten.uniq
  end


  def winner_name
    winner.try(:name)
  end

  def loser_name
    loser.try(:name)
  end

  def winner_new_position
    winner.try(:position)
  end

  def loser_new_position
    loser.try(:position)
  end


  private

  def winner_different_from_loser
    if winner_id == loser_id
      errors[:base] << "Winner and loser cannot be the same"
    end
  end

  def set_current_scores
    self.winner_current_score = winner.elo_rating
    self.loser_current_score = loser.elo_rating
  end

end
