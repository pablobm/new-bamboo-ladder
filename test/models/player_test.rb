require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  test "resets the ladder rank on creation" do
    player = Player.create(name: "John")
    assert_kind_of Integer, player.ladder_rank
  end

  test "ladder rank is unique" do
    p1 = Player.create(random_attrs.merge(ladder_rank: 55))
    p2 = Player.create(random_attrs.merge(ladder_rank: 55))
    assert p1.valid?, "The first user should be valid"
    refute p2.valid?, "The second user should NOT be valid"
    assert p2.errors[:ladder_rank], "The ladder_rank should have an error"
  end

  private

  def random_attrs
    name = random_str
    {
      name: name,
    }
  end
end
