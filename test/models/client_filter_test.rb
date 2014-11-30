require 'test_helper'

class ClientFilterTest < ActiveSupport::TestCase

  test "Comma-separated IP addresses" do
    cf = ClientFilter.new('1.2.3.4, 2.3.4.5')
    assert_equal true, cf.trusted?('1.2.3.4')
    assert_equal true, cf.trusted?('2.3.4.5')
    assert_equal false, cf.trusted?('1.2.3.5')
  end

  test "Wildcard" do
    cf = ClientFilter.new('*')
    assert_equal true, cf.trusted?('1.2.3.4')
    assert_equal true, cf.trusted?('2.3.4.5')
    assert_equal true, cf.trusted?('1.2.3.5')
  end

end
