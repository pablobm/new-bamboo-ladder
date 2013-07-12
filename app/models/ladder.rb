class Ladder
  include Singleton

  def resolve(result)
    User.transaction do
      transaction(result)
    end
  end

  def players
    User.where('position NOT NULL').order('position ASC')
  end


  private

  def transaction(result)
    positions = User.all.select(:id, :position).order('position ASC').map{|u| u.id }
    winner = result.winner
    loser = result.loser
    winner_index = positions.index{|id| id == winner.id}
    loser_index = positions.index{|id| id == loser.id}
    if winner_index < loser_index
      # Nothing to do
    elsif winner_index - loser_index < 3
      swap_positions(loser, winner)
    else
      move_position(winner, positions, 1)
      move_position(loser, positions, -1)
    end
  end

  def swap_positions(p1, p2)
    tmp = p1.position
    p1.position = p2.position
    p2.position = nil
    p2.save!
    p1.save!
    p2.position = tmp
    p2.save!
  end

  def move_position(player, positions, diff)
    player_index = positions.index{|uid| uid == player.id }
    swapper_id = positions[player_index - diff]
    if swapper = User.find_by_id(swapper_id)
      swap_positions(player, swapper)
    end
  end
end
