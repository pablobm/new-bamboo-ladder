require 'test_helper'

class EloRatingTest < ActiveSupport::TestCase

  private

  def elo
    EloRating.instance
  end

  def resolve(p1, p2)
    result = Result.create(winner: players(p1), loser: players(p2))
    elo.resolve(result)
  end


  public

  test "#resolve returns the number of points that changed hands" do
    dan_initial_elo = players(:dan).elo_rating

    resolution_diff = resolve(:dan, :carol)
    dan_diff = players(:dan).reload.elo_rating - dan_initial_elo

    assert_equal dan_diff, resolution_diff
  end

end
