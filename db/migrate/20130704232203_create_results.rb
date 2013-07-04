class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.references :winner
      t.references :loser
    end
  end
end
