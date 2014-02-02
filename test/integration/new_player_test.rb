require 'integration_test_helper'

class NewPlayerTest < CapybaraTestCase

  test "creating a new player" do
    assume_a_trusted_user

    click_on "Settings"

    within '.new-player' do
      fill_in "Name", with: "Iain"
      click_on "Add"
    end

    assert_ranking "Iain", 3
  end

end
