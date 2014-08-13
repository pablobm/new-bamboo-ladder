require 'test_helper'

class StateTest < ActiveSupport::TestCase

  private

  def play_some_games
    alice = players(:alice)
    bob = players(:bob)
    carol = players(:carol)

    NewResult.create!(winner: alice, loser: bob)
    NewResult.create!(winner: alice, loser: carol)
    NewResult.create!(winner: bob, loser: alice)
    NewResult.create!(winner: alice, loser: carol)
  end

  test "load state and list stored rankings" do
    players = [
      { 'id' => 11, 'elo_rating' => 1000 },
      { 'id' => 22, 'elo_rating' => 1111 },
      { 'id' => 55, 'elo_rating' => 1011 },
      { 'id' => 44, 'elo_rating' => 1011 },
      { 'id' => 33, 'elo_rating' => 1001 },
    ]
    dump = {'players' => players}

    state = State.load(dump)

    rs = state.players.sort_by(&:id)
    assert_equal rs[0].elo_rating, 1000
    assert_equal rs[0].id, 11

    assert_equal rs[4].elo_rating, 1011
    assert_equal rs[4].id, 55
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

  test ".rating_history_for" do
    alice = players(:alice)
    play_some_games

    expected = [1020, 1033, 1045, 1030, 1041]
    actual = State.rating_history_for(alice)

    assert_equal expected, actual
  end

  test ".max_historic_elo_value" do
    play_some_games

    assert_equal 1045, State.max_historic_elo_value
  end

end
