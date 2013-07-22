require 'test_helper'

class LadderProgressionTest < CapybaraTestCase
  test "moving up and down the ladder" do
    login
    assert_equal ['Alice', 'Bob', 'Carol', 'Dan', 'Erin'], ladder_names

    submit_result("Alice", "Carol")

    assert_equal ['Alice', 'Bob', 'Carol', 'Dan', 'Erin'], ladder_names

    submit_result("Carol", "Bob")

    assert_equal ['Alice', 'Carol', 'Bob', 'Dan', 'Erin'], ladder_names

    submit_result("Dan", "Carol")

    assert_equal ['Alice', 'Dan', 'Bob', 'Carol', 'Erin'], ladder_names

    submit_result("Erin", "Alice")

    assert_equal ['Dan', 'Alice', 'Bob', 'Erin', 'Carol'], ladder_names
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

  def ladder_names
    all('.ladder-name').map(&:text)
  end
end
