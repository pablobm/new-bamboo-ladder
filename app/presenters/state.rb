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
    # calculate positions if not present (older states don't have positions)
    dump['positions'] = positions_from_elos(dump['elo_ratings']) if !dump.key?('positions')

    elos = dump.fetch('elo_ratings', {})
    positions = dump.fetch('positions', {})
    non_positioned, positioned = positions.partition { |_, pos| pos.nil? }
    players = (positioned + non_positioned).map { |uid, position| Player.new(uid, elos[uid], position) }
    new(players)
  end

  private

  def self.positions_from_elos(elos)
    positions = {}
    position = 1
    previous_elo = nil
    non_rated, rated = elos.partition{|_, elo| elo.nil? }
    rated.sort_by{|_, elo| -elo }.each_with_index.map do |(uid, elo), i|
      position = i+1 if previous_elo != elo
      previous_elo = elo
      positions[uid] = position
    end
    non_rated.each { |uid, _| positions[uid] = nil }
    positions
  end

  class Player < Struct.new(:id, :elo_rating, :position); end

  def initialize(players)
    @players = players
  end

end
