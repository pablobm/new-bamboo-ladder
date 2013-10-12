require 'integration_test_helper'

class ResultMessagesTest < CapybaraTestCase

  test "spiffy messages announcing results" do
    assume_a_trusted_user

    submit_result("Alice", "Bob")

    assert_match '13', find('.flash-msg .points .figure').text
    assert_match '1st', find('.flash-msg .winner .figure').text
    assert_match '3rd', find('.flash-msg .loser .figure').text
  end

end
