require 'test_helper'

class ResultFlashTest < ActiveSupport::TestCase

  test "message" do
    r = Result.create!(winner: users(:alice), loser: users(:bob))
    flash = ResultFlash.new(result_id: r.id)
    assert_equal 'result', flash.template
  end

end
