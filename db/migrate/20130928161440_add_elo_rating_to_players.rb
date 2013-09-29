class AddEloRatingToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :elo_rating, :integer
  end
end
