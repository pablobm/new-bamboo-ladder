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
    {winner_position: winner_position, loser_position: loser_position, phrases: phrases}
  end


  private

  attr_reader :result

  def phrases
    winner_new_ordinal = ordinal_position(winner_position)
    loser_new_ordinal = ordinal_position(loser_position)
    {
      winner: %{#{result.winner_name} secures <span class="figure">#{winner_new_ordinal}</span> place}.html_safe,
      loser:  %{leaving #{result.loser_name} <span class="figure">#{loser_new_ordinal}</span>}.html_safe,
      points: %{Points transferred: <span class="figure">#{@points}</span>}.html_safe,
    }
  end

  def ordinal_position(position)
    ActiveSupport::Inflector.ordinalize(position)
  end

  def winner_position
    player_positions[result.winner.id]
  end

  def loser_position
    player_positions[result.loser.id]
  end

  def player_positions
    @player_positions ||= begin
      Player.in_elo_order.each_with_index.each_with_object({}) do |(player, position), memo|
        if player.id == result.winner.id || player.id == result.loser.id
          memo[player.id] = position + 1
        else
          memo
        end
      end
    end
  end

end
