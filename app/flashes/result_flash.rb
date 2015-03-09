class ResultFlash

  def initialize(opts)
    @winner_id = opts[:winner_id].to_i
    @loser_id = opts[:loser_id].to_i
    @points = opts[:points]
  end

  def template
    'flashes/result'
  end

  def locals
    {winner_position: winner_position, loser_position: loser_position, phrases: phrases}
  end


  private

  attr_reader :winner_id, :loser_id

  def phrases
    winner_new_ordinal = ordinal_position(winner_position)
    loser_new_ordinal = ordinal_position(loser_position)
    {
      winner: %{#{winner_name} secures <span class="figure">#{winner_new_ordinal}</span> place}.html_safe,
      loser:  %{leaving #{loser_name} <span class="figure">#{loser_new_ordinal}</span>}.html_safe,
      points: %{Points transferred: <span class="figure">#{@points}</span>}.html_safe,
    }
  end

  def ordinal_position(position)
    ActiveSupport::Inflector.ordinalize(position)
  end

  def winner_name
    player_positions[winner_id][:name]
  end

  def loser_name
    player_positions[loser_id][:name]
  end

  def winner_position
    player_positions[winner_id][:position]
  end

  def loser_position
    player_positions[loser_id][:position]
  end

  def player_positions
    @player_positions ||= begin
      Player.in_elo_order.each_with_index.reduce({}) do |memo, (player, position)|
        if player.id == winner_id || player.id == loser_id
          memo[player.id] = {name: player.name, position: position + 1}
        end

        memo
      end
    end
  end

end
