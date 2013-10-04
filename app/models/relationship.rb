# SOURCE: app/models/relationship.rb

class Relationship < ActiveRecord::Base
  # since there is neither a Followed nor a Follower model we need to supply the class name User
  # a relationship object belongs to both a follower and a followed user (followers and followeds have their own tables)
  belongs_to :follower, class_name: "User" # An individual Relationship table belonging to user_id symbol called :follower AKA the foreign key 'follower_id'
  belongs_to :followed, class_name: "User" # An Relationship table belongs to user_id symbol called :followed AKA the foreign key 'followed_id'
  
# In this case, both have their own (primary key) tables. 
## User.rb determines its place in Relationship class

  # follower AND followed are necessary to create a relationship (takes 2)
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end