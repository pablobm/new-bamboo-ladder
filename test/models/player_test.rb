require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  test ".in_elo_order" do
    alice = players(:alice)
    bob = players(:bob)
    carol = players(:carol)
    dan = players(:dan)
    erin = players(:erin)
    casper = players(:casper)

    carol.update_attributes(elo_rating: nil)
    dan.update_attributes(elo_rating: nil)

    expected_rated = [alice, bob, casper, erin]
    expected_unrated = [dan, carol]

    actual = Player.in_elo_order
    actual_rated = actual[0..3]
    actual_unrated = actual[4..5]

    assert_equal expected_rated, actual_rated
    assert_arrays_match expected_unrated, actual_unrated
  end

end
