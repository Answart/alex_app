# SOURCE: db/migrate/[timestamp]_create_relationships.rb
# Adding indices for the relationships table. 

class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    # follower/individual
    add_index :relationships, :follower_id
    # the one(s) being followed/senpais
    add_index :relationships, :followed_id
    # a composite index that enforces uniqueness of pairs of (follower_id,
    ## followed_id), so that a user can’t follow another user more than once
    # adding a unique index arranges to raise an error if a user tries to 
    ## create duplicate relationships anyway (using, e.g., a command-line tool
    ## such as curl)
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
