class ListedPlayer
  extend Forwardable

  attr_reader :position
  def_delegators :@player, :name

  def self.all
    last_rating = nil
    last_position = nil
    Player.in_elo_order.to_enum.with_index.map do |player, i|
      expected_position = i+1
      position = (last_rating == player.elo_rating) ? last_position : expected_position
      last_rating = player.elo_rating
      last_position = position
      new(position, player)
    end
  end

  def initialize(position, player)
    @position = position
    @player = player
  end

end
