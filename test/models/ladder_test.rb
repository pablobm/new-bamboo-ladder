require 'test_helper'

class LadderTest < ActiveSupport::TestCase

  def assert_ladder(*expected_order)
    assert_equal expected_order.map{|name| players(name).name }, Ladder.instance.players.map(&:name)
  end


  test "nothing changes if someone beats a player below them" do
    resolve_result(:alice, :bob)
    assert_ladder(:alice, :bob, :carol, :dan, :erin)
    resolve_result(:bob, :dan)
  end

  test "beat anyone above you and you move up one" do
    resolve_result(:erin, :alice)
    assert_ladder(:bob, :alice, :carol, :erin, :dan)
  end

  test "if a person beats the person above them, they change places" do
    resolve_result(:bob, :alice)
    assert_ladder(:bob, :alice, :carol, :dan, :erin)
  end

  test "if a person beats 2 places above them, they change places" do
    resolve_result(:carol, :alice)
    assert_ladder(:carol, :bob, :alice, :dan, :erin)
  end

  test "undo results" do
    r1 = resolve_result(:dan, :bob)
    r2 = resolve_result(:carol, :erin)
    r3 = resolve_result(:erin, :carol)

    assert_ladder(:alice, :dan, :erin, :bob, :carol)

    r3.destroy
    assert_ladder(:alice, :dan, :carol, :bob, :erin)

    r2.destroy
    assert_ladder(:alice, :dan, :carol, :bob, :erin)

    r1.destroy
    assert_ladder(:alice, :bob, :carol, :dan, :erin)
  end
end
