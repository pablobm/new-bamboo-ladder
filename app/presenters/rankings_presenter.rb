class RankingsPresenter

  def initialize(players)
    @players = players
  end

  def each(&block)
    rows.each(&block)
  end

  def rows
    @rows ||= begin
      @players.in_ladder_order.each_with_index.map do |p, i|
        RowPresenter.new({
          ladder_name: p.name,
          position: i+1,
          elo_name: players_in_elo_order[i].name,
          elo_rating: players_in_elo_order[i].elo_rating,
        })
      end
    end
  end


  private

  def players_in_elo_order
    @players_in_elo_order ||= Player.in_elo_order
  end

  class RowPresenter < OpenStruct; end
end
