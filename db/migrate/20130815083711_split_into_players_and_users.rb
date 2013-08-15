class SplitIntoPlayersAndUsers < ActiveRecord::Migration
  def self.up
    rename_table :users, :players
    create_table :users do |t|
      t.string :google_uid
      t.string :email
    end
    User.reset_column_information
    Player.reset_column_information
    Player.all.each do |p|
      User.create!(google_uid: p.google_uid, email: p.email)
    end

    remove_column :players, :google_uid
    remove_column :players, :email
  end

  def self.down
    raise IrreversibleMigration
  end
end
