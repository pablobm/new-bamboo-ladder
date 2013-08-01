require 'test_helper'

class MessagePresenterTest < ActiveSupport::TestCase

  test "provides a simple message" do
    u1 = users(:alice)
    u2 = users(:bob)
    r = Result.create!(winner: u1, loser: u2)
    p = MessagePresenter.new_result_summary(r)
    assert_equal I18n.t('result.summary', winner: u1.name, loser: u2.name), p.to_s
  end

end

