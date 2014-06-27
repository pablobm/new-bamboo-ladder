class State

  attr_reader :players

  def self.dump
    elo_ratings = {}
    positions = {}
    ::Player.all.each do |p|
      elo_ratings[p.id] = p.elo_rating
      positions[p.id] = p.position
    end
    {'elo_ratings' => elo_ratings, 'positions' => positions}
  end

  def self.load(dump)
    if dump.key?('positions')
      load_with_positions(dump)
    else
      load_without_positions(dump)
    end
  end


  private

  class Player < Struct.new(:id, :elo_rating, :position); end

  def initialize(players)
    @players = players
  end

  class << self
    def load_with_positions(dump)
      elos = dump['elo_ratings'] || {}
      positions = dump['positions'] || {}
      non_positioned, positioned = positions.partition { |_, pos| pos.nil? }
      players = (positioned + non_positioned).map { |uid, position| Player.new(uid, elos[uid], position) }
      new(players)
    end

    def load_without_positions(dump)
      elos = dump['elo_ratings'] || {}
      position = 1
      previous_elo = nil
      non_rated, rated = elos.partition{|_, elo| elo.nil? }
      rated_players = rated.sort_by{|_, elo| -elo }.each_with_index.map do |(uid, elo), i|
        position = i+1 if previous_elo != elo
        previous_elo = elo
        Player.new(uid, elo, position)
      end
      non_rated_players = non_rated.map{|id, _| Player.new(id)}
      new(rated_players + non_rated_players)
    end
  end

end
