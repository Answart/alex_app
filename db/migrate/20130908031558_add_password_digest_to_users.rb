# SOURCE: db/migrate/[ts]_add_password_digest_to_users.rb
# migration for the password_digest column

# add_password_digest_to_users password_digest:string
# add + something you said + to "users" table described
## in db/schema.rb as: password_digest: 'string'

class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
  end
end
