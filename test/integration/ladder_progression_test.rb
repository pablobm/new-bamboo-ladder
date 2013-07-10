require 'test_helper'

class LadderProgressionTest < CapybaraTestCase
  test "moving up and down the ladder" do
    login
    names = all('.ladder-player').map(&:text)
    assert_equal ['Alice', 'Bob', 'Carol', 'Dan', 'Erin'], names

    select "Alice", from: 'result[winner_id]'
    select "Carol", from: 'result[loser_id]'
    click_button "Submit"

    names = all('.ladder-player').map(&:text)
    assert_equal ['Alice', 'Bob', 'Carol', 'Dan', 'Erin'], names

    select "Carol", from: 'result[winner_id]'
    select "Bob", from: 'result[loser_id]'
    click_button "Submit"

    names = all('.ladder-player').map(&:text)
    assert_equal ['Alice', 'Carol', 'Bob', 'Dan', 'Erin'], names

    select "Dan", from: 'result[winner_id]'
    select "Carol", from: 'result[loser_id]'
    click_button "Submit"

    names = all('.ladder-player').map(&:text)
    assert_equal ['Alice', 'Dan', 'Bob', 'Carol', 'Erin'], names

    select "Erin", from: 'result[winner_id]'
    select "Alice", from: 'result[loser_id]'
    click_button "Submit"

    names = all('.ladder-player').map(&:text)
    assert_equal ['Dan', 'Alice', 'Bob', 'Erin', 'Carol'], names
  end

  def login
    visit root_path
    click_link "Log in"
    fill_in "Email", with: User.first.email
    click_button "Log in"
  end
end
