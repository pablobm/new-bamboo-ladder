require 'integration_test_helper'

class LadderProgressionTest < CapybaraTestCase
  test "moving up and down the ladder" do
    login
    assert_ladder ['Alice', 'Bob', 'Carol', 'Dan', 'Erin']

    submit_result("Alice", "Carol")
    assert_ladder ['Alice', 'Bob', 'Carol', 'Dan', 'Erin']

    submit_result("Carol", "Bob")
    assert_ladder ['Alice', 'Carol', 'Bob', 'Dan', 'Erin']

    submit_result("Dan", "Carol")
    assert_ladder ['Alice', 'Dan', 'Bob', 'Carol', 'Erin']

    submit_result("Erin", "Alice")
    assert_ladder ['Dan', 'Alice', 'Bob', 'Erin', 'Carol']
  end

end
