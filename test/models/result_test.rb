require 'test_helper'

class ResultTest < ActiveSupport::TestCase

  test "#winner_previous_position" do
    r = Result.new(winner: players(:erin), loser: players(:carol))
    r.previous_state = Player.in_order.map(&:id)

    assert_equal 5, r.winner_previous_position
    assert_equal 3, r.loser_previous_position
  end

end
