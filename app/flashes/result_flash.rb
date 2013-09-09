class ResultFlash

  def initialize(opts)
    if opts.key?(:result)
      @result = opts[:result]
    else
      result_id = opts.fetch(:result_id)
      @result = Result.find(result_id)
    end
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

    if @result.winner_previous_position == 1 &&
       [2, 3].include?(@result.loser_previous_position)
      {
        winner: "#{@result.winner_name} defended the title",
        loser:  "against pretender #{@result.loser_name}",
      }
    elsif @result.loser_previous_position == 1 &&
       [2, 3].include?(@result.winner_previous_position)
      {
        winner: "#{@result.winner_name} takes the top position",
        loser:  "relegating #{@result.loser_name} to #{loser_new_ordinal}",
      }
    elsif @result.loser_previous_position < @result.winner_previous_position
      {
        winner: "#{@result.winner_name} climbs to #{winner_new_ordinal} place",
        loser:  "leaving #{@result.loser_name} #{loser_new_ordinal}",
      }
    else
      {
        winner: "#{@result.winner_name} stays in #{winner_new_ordinal} place",
        loser:  "leaving #{@result.loser_name} #{loser_new_ordinal}",
      }
    end
  end

  def h
    @h ||= begin
      ret = Object.new
      ret.extend PositionHelper
      ret
    end
  end

end
