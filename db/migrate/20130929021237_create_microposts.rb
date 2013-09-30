# SOURCE: db/migrate/[timestamp]_create_microposts.rb
# a migration to create a microposts table in the database.

class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end
end

