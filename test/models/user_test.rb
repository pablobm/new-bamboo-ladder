require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "resets the position on creation" do
    user = User.create(google_uid: 'abc', email: 'jdoe@example.com', name: "John")
    assert_kind_of Integer, user.position
  end

  test "position is unique" do
    u1 = User.create(random_attrs.merge(position: 55))
    u2 = User.create(random_attrs.merge(position: 55))
    assert u1.valid?, "The first user should be valid"
    refute u2.valid?, "The second user should NOT be valid"
    assert u2.errors[:position], "The position should have an error"
  end


  private

  def random_attrs
    name = random_str
    {
      google_uid: 'google-' + name,
      email: name[0,2] + '@new-bamboo.co.uk',
      name: name,
      position: name,
    }
  end
end
