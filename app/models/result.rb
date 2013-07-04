class Result < ActiveRecord::Base

  belongs_to :winner, class_name: 'User'
  belongs_to :loser, class_name: 'User'

  validates :winner, presence: true
  validates :loser, presence: true
  validate :winner_different_from_loser

  private

  def winner_different_from_loser
    if winner_id == loser_id
      errors[:base] << "Winner and loser cannot be the same"
    end
  end

end
