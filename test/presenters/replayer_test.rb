require 'test_helper'

class ReplayerTest < ActiveSupport::TestCase

  teardown do
    Timecop.return
  end

  test "reliable when new players are added over time" do
    Player.update_all(elo_rating: EloRating.instance.initial_rating)
    alice = players(:alice)
    bob = players(:bob)
    carol = players(:carol)
    dan = players(:dan)
    erin = players(:erin)
    erin.update_attributes!(elo_rating: nil)

    NewResult.create!(winner_id: alice.id, loser_id: bob.id)
    NewResult.create!(winner_id: carol.id, loser_id: dan.id)

    Timecop.travel(3.weeks)
    NewResult.create!(winner_id: alice.id, loser_id: carol.id)
    NewResult.create!(winner_id: bob.id, loser_id: dan.id)

    Timecop.travel(3.weeks)
    NewResult.create!(winner_id: alice.id, loser_id: dan.id)
    NewResult.create!(winner_id: bob.id, loser_id: carol.id)

    alice.reload
    alice_rating = alice.elo_rating

    Replayer.instance.replay_all!

    alice.reload
    assert_equal alice_rating, alice.elo_rating
  end

end
