class TestsController < ApplicationController

  def show
    first = User.in_order.first
    second = User.in_order.second
    third = User.in_order.third
    last = User.in_order.last

    display_message_now(:result, result: Result.new(winner: first, loser: second, previous_state: User.state))
    display_message_now(:result, result: Result.new(winner: second, loser: first, previous_state: User.state))
    display_message_now(:result, result: Result.new(winner: third, loser: last, previous_state: User.state))
    display_message_now(:result, result: Result.new(winner: last, loser: second, previous_state: User.state))

    flash.now[:notice] = "This is a simple notice"
  end


end
