require 'test_helper'

class LadderTest < ActiveSupport::TestCase

  def resolve_result(winner, loser)
    result = Result.create!(winner: winner, loser: loser)
    ladder = Ladder.new(User.all)
    ladder.resolve(result)
    winner.reload
    loser.reload
  end

  test "nothing changes if someone beats a player below them" do
    p1 = users(:alice)
    pos1 = p1.position
    p2 = users(:bob)
    pos2 = p2.position
    resolve_result(p1, p2)
    assert_equal pos1, p1.position
    assert_equal pos2, p2.position
  end

  test "beat anyone above you and you move up one" do
    p1 = users(:erin)
    pos1 = p1.position
    p2 = users(:alice)
    pos2 = p2.position
    resolve_result(p1, p2)
    assert_equal pos1+1, p1.position
    assert_equal pos2-1, p2.position
  end

  test "if a person beats the person above them, they change places" do
    p1 = users(:bob)
    pos1 = p1.position
    p2 = users(:alice)
    pos2 = p2.position
    resolve_result(p1, p2)
    assert_equal pos2, p1.position
    assert_equal pos1, p2.position
  end

  test "if a person beats 2 places above them, they change places" do
    p1 = users(:carol)
    pos1 = p1.position
    p2 = users(:alice)
    pos2 = p2.position
    resolve_result(p1, p2)
    assert_equal pos2, p1.position
    assert_equal pos1, p2.position
  end

end
