class AddRemovedAtToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :removed_at, :datetime
  end
end
