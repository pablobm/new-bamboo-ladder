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

    expected = [alice, bob, casper, erin]
    actual = Player.in_elo_order
    assert_equal expected, actual
  end

end
