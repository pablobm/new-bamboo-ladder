ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

#
# Rails
#
require 'capybara/rails'
class CapybaraTestCase < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    Capybara.reset_session!
  end
end


#
# Helpers
#

def assert_arrays_match(expected, actual)
  assert_equal expected.sort, actual.sort
end
