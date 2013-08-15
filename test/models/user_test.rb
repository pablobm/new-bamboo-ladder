require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "must be from New Bamboo" do
    bad = User.create(random_attrs.merge(email: 'pablo@bamboo-new.co.uk'))
    good = User.create(random_attrs.merge(email: 'pablo@new-bamboo.co.uk'))
    refute bad.valid?, "Users must be from New Bamboo"
    assert good.valid?, "Users from New Bamboo are welcome"
  end


  private

  def random_attrs
    name = random_str
    {
      google_uid: 'google-' + name,
      email: name[0,2] + '@new-bamboo.co.uk',
    }
  end
end
