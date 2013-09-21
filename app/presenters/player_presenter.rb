class PlayerPresenter
  extend Forwardable

  def_delegators :@player, :name, :elo_rating

  def initialize(p, i)
    @player = p
    @index = i
  end

  def position
    @index + 1
  end

end
