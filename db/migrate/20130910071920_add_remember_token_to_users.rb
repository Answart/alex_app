# SOURCE: db/migrate/[ts]_add_remember_token_to_users.rb
# migration for the remember_token column and index

# add_remember_token_to_users
# add + something you said + to "users" table described
## in db/schema.rb as: password_digest: 'string'

class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :remember_token, :string
    add_index  :users, :remember_token
  end
end
