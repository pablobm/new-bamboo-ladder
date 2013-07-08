class Ladder
  def resolve(result)
    positions = User.all.select(:id, :position).order('position ASC').map{|u| [u.id, u.position] }
    winner_index = positions.index{|e| e.first == result.winner_id}
    loser_index = positions.index{|e| e.first == result.loser_id}
    if winner_index > loser_index
      # Nothing to do
    elsif loser_index - winner_index
    end
  end

  def players
    User.where('position NOT NULL').order('position ASC')
  end
end
