require 'test_helper'

class ResultFlashTest < ActiveSupport::TestCase

  test "standard message" do
    r = Result.create!(winner: users(:dan), loser: users(:carol))
    flash = ResultFlash.new(result_id: r.id)
    assert_equal 'flashes/result/standard', flash.template
  end

  test "first beats second" do
    r = Result.create!(winner: users(:alice), loser: users(:bob))
    flash = ResultFlash.new(result_id: r.id)
    assert_equal 'flashes/result/first_beats_second', flash.template
  end

end
