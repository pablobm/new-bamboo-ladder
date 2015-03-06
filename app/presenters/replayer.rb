class Replayer
  include Singleton

  def replay_all!
    replay_results!
  end


  private

  def replay_results!
    Result.transaction do
      Result.update_all(previous_state: nil)
      Player.update_all(elo_rating: nil)
      Result.in_order.each do |r|
        r.previous_state = State.dump
        elo_rating.resolve_with_result(r)
        r.save!
      end
    end
  end

  def elo_rating
    @elo_rating ||= EloRating.instance
  end

end
