class ResultFlash

  def initialize(opts)
    if opts.key?(:result)
      @result = opts[:result]
    else
      result_id = opts.fetch(:result_id)
      @result = Result.find(result_id)
    end
    @points = opts[:points]
  end

  def template
    'flashes/result'
  end

  def locals
    {result: @result, phrases: phrases}
  end


  private

  def phrases
    winner_new_ordinal = h.ordinal_position(@result.winner)
    loser_new_ordinal = h.ordinal_position(@result.loser)
    {
      winner: %{#{@result.winner_name} secures <span class="figure">#{winner_new_ordinal}</span> place}.html_safe,
      loser:  %{leaving #{@result.loser_name} <span class="figure">#{loser_new_ordinal}</span>}.html_safe,
      points: %{Points transferred: <span class="figure">#{@points}</span>}.html_safe,
    }
  end

  def h
    @h ||= begin
      ret = Object.new
      ret.extend PositionHelper
      ret
    end
  end

end
