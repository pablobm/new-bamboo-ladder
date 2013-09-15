class Result < ActiveRecord::Base

  belongs_to :winner, class_name: 'Player'
  belongs_to :loser, class_name: 'Player'

  validates :winner, presence: true
  validates :loser, presence: true
  validate :winner_different_from_loser

  serialize :previous_state, Array

  after_create :resolve_ladder
  after_create :resolve_elo_ratings
  after_destroy :undo

  def self.latest_first
    self.order('created_at DESC')
  end

  def self.in_order
    self.order('created_at ASC')
  end

  def winner_name
    winner.try(:name)
  end

  def loser_name
    loser.try(:name)
  end


  private

  def winner_different_from_loser
    if winner_id == loser_id
      errors[:base] << "Winner and loser cannot be the same"
    end
  end

  def resolve_ladder
    ladder.resolve(self)
  end

  def resolve_elo_ratings
    elo.resolve(self)
  end

  def undo
    ladder.undo(self)
  end

  def ladder
    @ladder ||= Ladder.instance
  end

  def elo
    @elo ||= EloRating.instance
  end
end
