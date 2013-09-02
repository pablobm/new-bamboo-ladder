require 'test_helper'

class ResultFlashTest < ActiveSupport::TestCase

  test "second beats first" do
    assert_result_flash 'second_beats_first', :bob, :alice
  end

  test "first beats second" do
    assert_result_flash 'first_beats_second', :alice, :bob
  end

  test "no change in ladder" do
    assert_result_flash 'ladder_unchanged', :alice, :erin
  end

  test "change in ladder" do
    assert_result_flash 'ladder_changed', :erin, :alice
  end


  private

  def assert_result_flash(template, winner, loser)
    r = Result.create!(winner: users(winner), loser: users(loser))
    flash = ResultFlash.new(result_id: r.id)
    assert_equal "flashes/result/#{template}", flash.template
  end

end
