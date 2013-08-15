require 'test_helper'

class EloRatingTest < ActiveSupport::TestCase

  test "general behaviour" do
    assert_equal rating(:alice), rating(:bob)
    assert_equal rating(:alice), rating(:carol)

    resolve_result(:alice, :carol)
    assert_operator rating(:alice), :>, rating(:carol)
    assert_equal rating(:bob), rating(:dan)

    resolve_result(:alice, :bob)
    assert_operator rating(:alice), :>, rating(:bob)
    assert_operator rating(:alice), :>, rating(:carol)

    resolve_result(:bob, :carol)
    assert_operator rating(:alice), :>, rating(:bob)
    assert_operator rating(:alice), :>, rating(:carol)
    assert_operator rating(:bob), :>, rating(:carol)
  end

  def rating(fixture)
    players(fixture).elo_rating
  end

end
