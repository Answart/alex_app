# SOURCE: db/migrate/[timestamp]_add_index_to_users_email.rb
# To enforce email uniqueness at the database level as well, 
## a database index is created on the email column, 
## which requires that the index be unique.
# email index represents an update to our data modeling requirements, which (as discussed in Section 6.1.1) is handled in Rails using migrations.
# we are adding structure to an existing model

# defined email uniqueness migration
class AddIndexToUsersEmail < ActiveRecord::Migration

  def change
  	# add an index on the email column of the users table
  	add_index :users, :email, unique: true
  end
end


# NOW: this file makes changes to: db/schema.rb