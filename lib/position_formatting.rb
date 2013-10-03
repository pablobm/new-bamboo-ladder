module PositionFormatting
  def ordinal_position(player)
    ordinal(player.position)
  end

  def ordinal(integer)
    ActiveSupport::Inflector.ordinalize(integer)
  end
end
