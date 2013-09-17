require 'test_helper'

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

def assert_ladder(expected_names)
  assert_equal expected_names, ladder_names
end

def ladder_names
  all('.ladder .player-name').map(&:text)
end
