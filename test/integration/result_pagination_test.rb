require 'integration_test_helper'

class RankingPaginationTest < CapybaraTestCase

  test "results are split between several pages" do
    assume_a_trusted_user

    submit_result("Carol", "Alice")
    submit_result("Bob", "Dan")
    submit_result("Bob", "Erin")
    submit_result("Alice", "Bob")

    visit '/results?per_page=3'

    assert page.has_content?("Alice beat Bob")
    assert page.has_content?("Bob beat Erin")
    assert page.has_content?("Bob beat Dan")

    assert page.has_no_content?("Carol beat Alice")

    click_on "Next"

    assert page.has_content?("Carol beat Alice")

    click_on "Prev"

    assert page.has_no_content?("Carol beat Alice")

    assert page.has_content?("Alice beat Bob")
  end

end
