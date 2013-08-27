class ResultFlash

  def initialize(opts)
    result_id = opts.fetch(:result_id)
    @result = Result.find(result_id)
  end

  def template
    if @result.winner_previous_position == 1 &&
       [2, 3].include?(@result.loser_previous_position)
      'flashes/result/first_beats_second'
    elsif @result.loser_previous_position == 1 &&
       [2, 3].include?(@result.winner_previous_position)
      'flashes/result/second_beats_first'
    else
      'flashes/result/standard'
    end
  end

  def locals
    {result: @result}
  end

end
