require 'test_helper'

class EloRatingTest < ActiveSupport::TestCase

  private

  def elo
    EloRating.instance
  end

  def resolve(p1, p2)
    elo.resolve(p1.id, p2.id)
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

    resolve(bob, erin)
    bob.reload

    assert_not_nil bob.elo_rating
  end

end
