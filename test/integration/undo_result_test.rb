require 'integration_test_helper'

class UndoResultTest < CapybaraTestCase

  test "undoing an incorrect result" do
    login

    submit_result("Erin", "Alice")
    assert_rankings "Erin", :>, "Dan"
    within '#flash' do
      click_on "undo"
    end
    click_on "Yeah"
    assert_rankings "Dan", :>, "Erin"
  end

end
