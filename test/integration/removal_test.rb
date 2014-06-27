require 'integration_test_helper'

class RankingsTest < CapybaraTestCase
  test 'removed players are not visible' do
    assume_a_trusted_user

    assert_ranking 'Bob', 2
    assert_elo 'Bob', 1010

    assert_ranking 'Carol', 3
    assert_elo 'Carol', 1000

    assert_ranking 'Dan', 4
    assert_elo 'Dan', 990

    click_on 'Carol'

    click_on 'Remove player'

    assert_match 'Carol has been removed', find('.flash-msg').text

    assert_ranking 'Bob', 2
    assert_elo 'Bob', 1010

    assert_not_ranked 'Carol'
    assert_not_scored 'Carol'

    assert_ranking 'Dan', 3
    assert_elo 'Dan', 990
  end
end
