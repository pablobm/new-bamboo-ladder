class Ladder
  include Singleton

  def resolve(result)
    Player.transaction do
      result.previous_state = Player.state
      result.save!
      transaction(result)
    end
  end

  def undo(result)
    Player.transaction do
      Player.update_all(ladder_rank: nil)
      result.previous_state.each_with_index do |uid, i|
        u = Player.find(uid)
        u.ladder_rank = i
        u.save!
      end
      Result.where('id > ?', result.id).order('id ASC').each do |r|
        resolve(r)
      end
    end
  end

  def players
    Player.where('ladder_rank NOT NULL').order('ladder_rank ASC')
  end


  private

  def transaction(result)
    ranks = Player.in_ladder_order.select(:id, :ladder_rank).map{|u| u.id }
    winner = result.winner
    loser = result.loser
    winner_index = ranks.index{|id| id == winner.id}
    loser_index = ranks.index{|id| id == loser.id}
    if winner_index < loser_index
      # Nothing to do
    elsif winner_index - loser_index < 3
      swap_ranks(loser, winner)
    else
      move_rank(winner, ranks, 1)
      move_rank(loser, ranks, -1)
    end
  end

  def swap_ranks(p1, p2)
    tmp = p1.ladder_rank
    p1.ladder_rank = p2.ladder_rank
    p2.ladder_rank = nil
    p2.save!
    p1.save!
    p2.ladder_rank = tmp
    p2.save!
  end

  def move_rank(player, ranks, diff)
    player_index = ranks.index{|uid| uid == player.id }
    swapper_id = ranks[player_index - diff]
    if swapper = Player.find_by_id(swapper_id)
      swap_ranks(player, swapper)
    end
  end
end
