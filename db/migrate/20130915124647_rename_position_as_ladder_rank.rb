class RenamePositionAsLadderRank < ActiveRecord::Migration
  def change
    rename_column :players, :position, :ladder_rank
  end
end
