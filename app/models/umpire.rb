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
    Player.update_all(position: nil)
    INITIAL_LADDER.each_with_index do |name, i|
      user = Player.find_by_name!(name)
      user.position = i
      user.save!
    end
    last_position = Player.all.inject(0){|max, p| max < p.position.to_i ? p.position.to_i : max }
    Player.where(position: nil).each do |p|
      last_position += 1
      p.position = last_position
      p.save!
    end
  end


  private

  def replay_results!
    Result.all.each do |r|
      Result.transaction do
        r.previous_state = Player.in_order.map(&:id)
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
