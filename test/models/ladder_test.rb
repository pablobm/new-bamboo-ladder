require 'test_helper'

class LadderTest < ActiveSupport::TestCase

  def resolve_result(winner, loser)
    result = Result.create!(winner: users(winner), loser: users(loser))
    #@ladder.resolve(result)
  end

  def assert_ladder(*expected_order)
    assert_equal expected_order.map{|name| users(name).name }, @ladder.players.map(&:name)
  end


  def setup
    @ladder = Ladder.instance
  end


  test "nothing changes if someone beats a player below them" do
    resolve_result(:alice, :bob)
    assert_ladder(:alice, :bob, :carol, :dan, :erin)
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

end
