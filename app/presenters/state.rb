class State

  attr_reader :players

  def self.dump
    elo_ratings = ::Player.all.inject({}) do |memo, p|
      memo[p.id] = p.elo_rating
      memo
    end
    {elo_ratings: elo_ratings}
  end

  def self.load(dump)
    elos = dump[:elo_ratings] || {}
    position = 1
    previous_elo = nil
    players = elos.sort_by{|_, elo| -elo }.each_with_index.map do |(uid, elo), i|
      position = i+1 if previous_elo != elo
      previous_elo = elo
      Player.new(uid, elo, position)
    end
    new(players)
  end


  private

  class Player < Struct.new(:id, :elo_rating, :position); end


  def initialize(players)
    @players = players
  end

end
