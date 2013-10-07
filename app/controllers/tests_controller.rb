class TestsController < ApplicationController

  def show
    first = Player.in_elo_order.first
    second = Player.in_elo_order.second
    third = Player.in_elo_order.third
    last = Player.in_elo_order.last

    display_message_now(:result, result: Result.new(winner: first, loser: second, previous_state: State.dump), points: 1)
    display_message_now(:result, result: Result.new(winner: second, loser: first, previous_state: State.dump), points: 12)
    display_message_now(:result, result: Result.new(winner: third, loser: last, previous_state: State.dump), points: 123)
    display_message_now(:result, result: Result.new(winner: last, loser: second, previous_state: State.dump), points: 1234)

    flash.now[:notice] = "This is a simple notice"
    flash.now[:alert] = "Alert! Achtung!"
  end


end
