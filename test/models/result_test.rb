require 'test_helper'

class ResultTest < ActiveSupport::TestCase

  test ".participant_ids" do
    alice = players(:alice)
    bob = players(:bob)
    carol = players(:carol)

    Result.create(winner: alice, loser: bob)
    Result.create(winner: bob, loser: carol)

    expected = [alice, bob, carol].map(&:id).sort
    actual = Result.all.participant_ids.sort

    assert_equal expected, actual
  end

end
