require 'test_helper'

class LadderProgressionTest < CapybaraTestCase
  test "moving up and down the ladder" do
    login
    names = all('.ladder-entry').map(&:text)
    assert_equal ['Alice', 'Bob', 'Carol', 'Dan', 'Erin'], names

    submit_result("Alice", "Carol")

    names = all('.ladder-entry').map(&:text)
    assert_equal ['Alice', 'Bob', 'Carol', 'Dan', 'Erin'], names

    submit_result("Carol", "Bob")

    names = all('.ladder-entry').map(&:text)
    assert_equal ['Alice', 'Carol', 'Bob', 'Dan', 'Erin'], names

    submit_result("Dan", "Carol")

    names = all('.ladder-entry').map(&:text)
    assert_equal ['Alice', 'Dan', 'Bob', 'Carol', 'Erin'], names

    submit_result("Erin", "Alice")

    names = all('.ladder-entry').map(&:text)
    assert_equal ['Dan', 'Alice', 'Bob', 'Erin', 'Carol'], names
  end

  def login
    visit root_path
    click_link "Log in"
    fill_in "Email", with: User.first.email
    click_button "Log in"
  end

  def submit_result(winner, loser)
    select winner, from: 'result[winner_id]'
    select loser, from: 'result[loser_id]'
    within '.result-form' do
      find('[type=submit]').click
    end
  end
end
