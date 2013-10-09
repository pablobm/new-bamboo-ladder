require 'test_helper'

class StateTest < ActiveSupport::TestCase

  test "load state and list stored rankings" do
    elos = {
      11 => 1000,
      22 => 1111,
      55 => 1011,
      44 => 1011,
      33 => 1001,
    }
    dump = {elo_ratings: elos}

    state = State.load(dump)

    rs = state.players
    assert_equal rs[0].position, 1
    assert_equal rs[0].elo_rating, 1111
    assert_equal rs[0].id, 22

    assert_equal rs[1].position, 2
    assert_equal rs[2].position, 2

    assert_equal rs[4].position, 5
    assert_equal rs[4].elo_rating, 1000
    assert_equal rs[4].id, 11
  end

  test "it doesn't complain when players have no rating" do
    players(:erin).update_attributes({
      elo_rating: nil,
      position: nil,
    })

    dump1 = State.dump
    State.load(dump1)
    dump2 = State.dump
    assert_equal dump1, dump2
  end

end
