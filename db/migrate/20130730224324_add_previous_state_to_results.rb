class AddPreviousStateToResults < ActiveRecord::Migration
  def change
    add_column :results, :previous_state, :text
  end
end
