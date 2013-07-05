class AddPositionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :position, :integer

    populate_positions unless reverting?
  end

  def populate_positions
    User.all.each_with_index do |user, i|
      user.position = i
      user.save!
    end
  end
end
