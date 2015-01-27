require 'integration_test_helper'

class UndoResultTest < CapybaraTestCase

  test "removing an incorrect result" do
    assume_a_trusted_user

    submit_result("Erin", "Alice")
    assert_ranking "Erin", 4
    assert_ranking "Alice", 2

    submit_result("Erin", "Dan")
    assert_ranking "Erin", 2
    assert_ranking "Alice", 3

    submit_result("Alice", "Bob")
    assert_ranking "Alice", 1
    assert_ranking "Bob", 4

    within '#flash' do
      click_on "undo"
    end
    click_on "Yeah"

    assert_ranking "Erin", 2
    assert_ranking "Alice", 3

    visit undo_results_path
    click_on "Yeah"

    assert_ranking "Erin", 4
    assert_ranking "Alice", 2

    visit undo_results_path
    click_on "Yeah"

    assert_ranking "Erin", 5
    assert_ranking "Alice", 1
  end

  test "modifying an incorrect result" do
    assume_a_trusted_user

    submit_result("Erin", "Alice")
    submit_result("Erin", "Dan")
    submit_result("Alice", "Bob")

    # At the moment, there is no interface for this
    # This has to be done on the console
    dan = Player.find_by_name("Dan")
    erin = Player.find_by_name("Erin")
    r = Result.where(loser_id: dan.id).first
    r.winner_id = dan.id
    r.loser_id = erin.id
    r.save!
    EloRating.instance.resolve_from(r)

    reload_page
    assert_ranking "Alice", 1
    assert_ranking "Dan", 2
    assert_ranking "Carol", 3
    assert_ranking "Bob", 4
    assert_ranking "Erin", 5
  end

end
