class Replayer
  include Singleton

  def replay_all!
    reset_elo_ratings!
    replay_results!
  end

  def reset_elo_ratings!
    new_player = Elo::Player.new
    Player.update_all(elo_rating: new_player.rating)
  end


  private

  def replay_results!
    Result.update_all(previous_state: nil)
    Result.transaction do
      Result.in_order.each do |r|
        r.previous_state = State.dump
        elo_rating.resolve(r)
        r.save!
      end
    end
  end

  def elo_rating
    @elo_rating ||= EloRating.instance
  end

end
