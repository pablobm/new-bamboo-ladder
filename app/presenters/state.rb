class State

  attr_reader :players

  def self.dump
    elo_ratings = ::Player.all.inject({}) do |memo, p|
      memo[p.id] = p.elo_rating
      memo
    end
    {'elo_ratings' => elo_ratings}
  end

  def self.load(dump)
    elos = dump['elo_ratings'] || {}
    non_rated, rated = elos.partition{|_, elo| elo.nil? }
    rated_players = rated.sort_by{|_, elo| -elo }.map do |(uid, elo)|
      Player.new(uid, elo)
    end
    non_rated_players = non_rated.map{|id, _| Player.new(id)}
    new(rated_players + non_rated_players)
  end


  private

  class Player < Struct.new(:id, :elo_rating); end

  def initialize(players)
    @players = players
  end

end
