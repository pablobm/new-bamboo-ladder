class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :google_uid
      t.string :email
      t.string :name
    end
  end
end
