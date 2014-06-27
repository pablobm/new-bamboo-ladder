require 'test_helper'

class EloRatingTest < ActiveSupport::TestCase

  private

  def elo
    EloRating.instance
  end

  def resolve(p1, p2)
    result = Result.create(winner: p1, loser: p2)
    elo.resolve(result)
  end


  public

  test "#resolve returns the number of points that changed hands" do
    dan = players(:dan)
    carol = players(:carol)
    dan_initial_elo = dan.elo_rating

    resolution_diff = resolve(dan, carol)
    dan_diff = dan.reload.elo_rating - dan_initial_elo

    assert_equal dan_diff, resolution_diff
  end

  test "#resolve resets the score of players without score" do
    bob = players(:bob)
    erin = players(:erin)
    bob.update_attribute(:elo_rating, nil)
    bob.update_attribute(:position, nil)

    resolve(bob, erin)
    bob.reload

    assert_not_nil bob.elo_rating
    assert_not_nil bob.position
  end

  test '#recalculate_positions does not position inactive players' do
    bob = players(:bob)
    carol = players(:carol)
    erin = players(:erin)

    assert_equal 2, bob.position
    assert_equal 3, carol.position
    assert_equal 5, erin.position

    carol.remove

    elo.recalculate_positions

    assert_equal 2, bob.reload.position
    assert_equal nil, carol.reload.position
    assert_equal 4, erin.reload.position
  end

end
