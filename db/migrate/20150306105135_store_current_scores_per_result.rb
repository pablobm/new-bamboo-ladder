class StoreCurrentScoresPerResult < ActiveRecord::Migration
  def change
    add_column :results, :winner_current_score, :integer
    add_column :results, :loser_current_score, :integer
  end
end
