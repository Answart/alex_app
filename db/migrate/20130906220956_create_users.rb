# SOURCE: db/migrate/[timestamp]_create_users.rb
# when migration file for USER model is made, 'def change' determines what changes in the db
## Rails uses this timestamp to determine which migration should be run and in what order, so if you're copying a migration from another application or generate a file yourself, be aware of its position in the order.
### 'Migrations provide a way to alter the structure of the database incrementally, so that our data model can adapt to changing requirements.'

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end


# NOW: this file makes changes to: db/schema.rb