class State

  attr_reader :players

  def self.dump
    players = ::Player.all.map{|p| State::Player.new(p.id, p.elo_rating, p.active).as_json }
    { 'players' => players }
  end

  def self.load(raw_dump)
    players = raw_dump['players'].map{|hsh| State::Player.new_from_hash(hsh) }
    new(players: players)
  end

  def self.rating_history_for(player)
    player_history = latest_states_for(player).map{|state| state.find_player_by_id(player.id) }
    player_history.map(&:elo_rating) + [player.elo_rating]
  end

  def self.latest_states_for(player)
    player.results.latest_first.limit(50).map(&:previous_state)
  end

  def self.max_historic_elo_value
    Result.select(%{json_array_elements(raw_previous_state->'players')->'elo_rating' AS elo_rating}).map(&:elo_rating).compact.max
  end

  def find_player_by_id(player_id)
    @ordered_players.find{|p| p['id'] == player_id }
  end

  def position_for(player)
    @ordered_players.
  end


  private

  def initialize(hsh)
    @ordered_players = hsh[:players].sort_by(&:elo_rating).reverse
  end

  class Player < Struct.new(:id, :elo_rating, :active)
    def self.new_from_hash(hsh)
      hsh = hsh.stringify_keys
      new(hsh['id'], hsh['elo_rating'], hsh['active'])
    end
  end

end
