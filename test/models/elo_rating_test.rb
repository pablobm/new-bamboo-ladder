require 'test_helper'

class EloRatingTest < ActiveSupport::TestCase

  def setup
    Umpire.instance.reset_elo_ratings!
  end

  def teardown
    Delorean.back_to_the_present
  end

  test "general behaviour" do
    assert_equal rating(:alice), rating(:bob)
    assert_equal rating(:alice), rating(:carol)
    assert_equal rating(:alice), rating(:dan)

    resolve_result(:alice, :carol)
    assert_operator rating(:alice), :>, rating(:bob)
    assert_operator rating(:alice), :>, rating(:carol)
    assert_operator rating(:alice), :>, rating(:dan)
    assert_equal rating(:bob), rating(:dan)
    assert_operator rating(:bob), :>, rating(:carol)

    resolve_result(:alice, :bob)
    assert_operator rating(:alice), :>, rating(:bob)
    assert_operator rating(:alice), :>, rating(:carol)

    resolve_result(:bob, :carol)
    assert_operator rating(:alice), :>, rating(:bob)
    assert_operator rating(:alice), :>, rating(:carol)
    assert_operator rating(:bob), :>, rating(:carol)
  end

  test "inactive players lose their points" do
    elo_pool_initial = Player.sum(:elo_rating)
    resolve_result(:alice, :bob)
    resolve_result(:carol, :dan)
    a_rating0 = rating(:alice)
    c_rating0 = rating(:carol)

    Delorean.jump 3.weeks
    a_rating1 = rating(:alice)
    c_rating1 = rating(:carol)
    assert_equal a_rating1, a_rating0
    assert_equal c_rating1, c_rating0

    resolve_result(:alice, :dan)
    a_rating2 = rating(:alice)
    c_rating2 = rating(:carol)
    assert_operator a_rating2, :>, a_rating1
    assert_equal c_rating2, c_rating1

    Delorean.jump 1.week + 1.day
    resolve_result(:bob, :dan)
    a_rating3 = rating(:alice)
    c_rating3 = rating(:carol)
    assert_operator a_rating3, :>, a_rating2
    assert_operator c_rating3, :<, c_rating2

    elo_pool_final = Player.sum(:elo_rating)
    assert_in_delta elo_pool_initial, elo_pool_final, Player.count, "The total number of points did not stay (roughly) the same (It started at #{elo_pool_initial} and ended at #{elo_pool_final})"
  end

  test "points pool remains stable (with max variation == num_players)" do
    elo_pool_initial = Player.sum(:elo_rating)
    54.times do
      winner, loser = Player.all.sample(2)
      resolve_result(winner, loser)
    end
    elo_pool_final = Player.sum(:elo_rating)

    assert_in_delta elo_pool_initial, elo_pool_final, Player.count, "The total number of points did not stay (roughly) the same (It started at #{elo_pool_initial} and ended at #{elo_pool_final})"
  end

  def rating(fixture)
    players(fixture).reload
    players(fixture).elo_rating
  end

end
