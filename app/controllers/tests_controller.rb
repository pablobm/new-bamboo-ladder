class TestsController < ApplicationController

  def show
    first = Player.in_ladder_order.first
    second = Player.in_ladder_order.second
    third = Player.in_ladder_order.third
    last = Player.in_ladder_order.last

    display_message_now(:result, result: Result.new(winner: first, loser: second, previous_state: Player.state))
    display_message_now(:result, result: Result.new(winner: second, loser: first, previous_state: Player.state))
    display_message_now(:result, result: Result.new(winner: third, loser: last, previous_state: Player.state))
    display_message_now(:result, result: Result.new(winner: last, loser: second, previous_state: Player.state))

    flash.now[:notice] = "This is a simple notice"
    flash.now[:alert] = "Alert! Achtung!"
  end


end
