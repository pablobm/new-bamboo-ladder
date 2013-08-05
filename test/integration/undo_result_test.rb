require 'integration_test_helper'

class UndoResultTest < CapybaraTestCase

  test "undoing an incorrect result" do
    login

    submit_result("Erin", "Alice")
    assert_ladder ['Bob', 'Alice', 'Carol', 'Erin', 'Dan']
    within '#flash' do
      click_on "undo"
    end
    click_on "Yeah"
    assert_ladder ['Alice', 'Bob', 'Carol', 'Dan', 'Erin']
  end

end
