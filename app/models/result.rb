class Result < ActiveRecord::Base

  belongs_to :winner, class_name: 'User'
  belongs_to :loser, class_name: 'User'

  validates :winner, presence: true
  validates :loser, presence: true
  validate :winner_different_from_loser

  serialize :previous_state, Array

  after_create :resolve_ladder
  after_destroy :undo

  def self.latest_first
    self.order('id DESC')
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

  def winner_previous_position
    @winner_previous_position ||=
      previous_state.index(winner_id) + 1
  end

  def loser_previous_position
    @loser_previous_position ||=
      previous_state.index(loser_id) + 1
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

  def undo
    ladder.undo(self)
  end

  def ladder
    @ladder ||= Ladder.instance
  end
end
