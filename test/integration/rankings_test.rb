require 'integration_test_helper'

class RankingsTest < CapybaraTestCase

  test "progression after a few games" do
    Player.update_all(elo_rating: 1000)
    login

    submit_result("Carol", "Alice")
    submit_result("Bob", "Dan")

    # Winners ahead of less lucky players
    assert_rankings "Carol", :>, "Alice"
    assert_rankings "Bob", :>, "Dan"

    # Winners together, and so are losers
    assert_rankings "Carol", :==, "Bob"
    assert_rankings "Alice", :==, "Dan"

    # Non-players stay in the middle (for now)
    assert_rankings "Carol", :>, "Erin"
    assert_rankings "Erin", :>, "Alice"

    submit_result("Bob", "Carol")
    assert_rankings "Bob", :>, "Carol"
  end

end
