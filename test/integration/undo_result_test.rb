require 'integration_test_helper'

class UndoResultTest < CapybaraTestCase

  test "undoing an incorrect result" do
    login

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

end
