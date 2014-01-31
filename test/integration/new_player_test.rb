require 'integration_test_helper'

class NewPlayerTest < CapybaraTestCase

  test "creating a new player" do
    assume_a_trusted_user

    click_on "New player"

    fill_in "Name", with: "Iain"

    click_on "Add"

    assert_ranking "Iain", 3
  end

end
