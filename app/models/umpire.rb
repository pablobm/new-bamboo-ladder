class Umpire
  include Singleton

  INITIAL_LADDER = [
    'Tom',
    'Sam W.',
    'Ismael',
    'Mark',
    'Olly',
    'Ben',
    'Ollie N.',
    'Laurie',
    'Dan',
    'Claudio',
    'Vivien',
    'Tony',
    'Gwyn',
    'Oscar',
    'Joe',
    'Niall',
    'Pablo',
    'Lee',
  ]

  def replay_all!
    reset_elo_ratings!
    reset_ladder!
    replay_results!
  end

  def reset_elo_ratings!
    new_player = Elo::Player.new
    Player.update_all(elo_rating: new_player.rating)
  end

  def reset_ladder!
    Player.update_all(ladder_rank: nil)
    INITIAL_LADDER.each_with_index do |name, i|
      user = Player.find_by_name!(name)
      user.ladder_rank = i
      user.save!
    end
    last_rank = Player.all.inject(0){|max, p| max < p.ladder_rank.to_i ? p.ladder_rank.to_i : max }
    Player.where(ladder_rank: nil).each do |p|
      last_rank += 1
      p.ladder_rank = last_rank
      p.save!
    end
  end


  private

  def replay_results!
    Result.all.each do |r|
      Result.transaction do
        r.previous_state = Player.in_ladder_order.map(&:id)
        ladder.resolve(r)
        elo_rating.resolve(r)
      end
    end
  end

  def ladder
    @ladder ||= Ladder.instance
  end

  def elo_rating
    @elo_rating ||= EloRating.instance
  end

end
