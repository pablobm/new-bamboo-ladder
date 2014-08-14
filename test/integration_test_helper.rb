require 'test_helper'

def assume_a_trusted_user
  visit '/'
  page.driver.request.env['REMOTE_ADDR'] = Figaro.env.trusted_ips.split(',').first
end

def submit_result(winner, loser)
  select winner, from: 'result[winner_id]'
  select loser, from: 'result[loser_id]'
  within '.result-form' do
    find('[type=submit]').click
  end
end

def assert_rankings(name1, operator, name2)
  assert_operator ranking_of(name2), operator, ranking_of(name1)
end

def assert_ranking(name, position)
  assert_equal position, ranking_of(name)
end

def assert_not_ranked(name)
  assert_nil ranking_of(name)
end

def ranking_of(name)
  results_by_name.fetch(name, {})[:ranking]
end

def results_by_name
  previous_ranking = 0
  all('.rankings-entry').inject({}) do |memo, entry|
    name = entry.find('.rankings-name').text
    ranking = entry.find('.rankings-position').text.to_i
    elo = entry.find('.rankings-elo').text.to_i
    if ranking < previous_ranking
      flunk "WUT? Player #{name}'s position is not consistent with its position on the list"
    end
    previous_ranking = ranking
    memo[name] = { ranking: ranking, elo: elo }
    memo
  end
end

def assert_elos(name1, operator, name2)
  assert_operator elo_of(name2), operator, elo_of(name1)
end

def assert_elo(name, score)
  assert_equal score, elo_of(name)
end

def assert_not_scored(name)
  assert_nil elo_of(name)
end

def elo_of(name)
  results_by_name.fetch(name, {})[:elo]
end
