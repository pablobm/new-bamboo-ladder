class UseJsonForState < ActiveRecord::Migration
  def change
    rename_column :results, :previous_state, :old_previous_state
    add_column :results, :raw_previous_state, :json
  end
end
