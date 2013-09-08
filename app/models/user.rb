# SOURCE: app/models/user.rb
# code for the User model for when a potential User is created.
# a created User is an accepted User because when has the following...
# if a blank User is created, alex_app creates one based on these stats (ids with nil values).

class User < ActiveRecord::Base

  # make sure that the email address is all lower-case before it gets
  ## saved to the database because not all database adapters
  ## use case-sensitive indices
  # sets the user’s email address to a lower-case version of its current value
  before_save { self.email = email.downcase }

  # ensure that each 'USER' has the following:
  validates :name,  presence: true, length: { maximum: 50 }
  # STARTS_WITH_CAPS = constant defined by ruby
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX }, 
  # since it is not case sensitive, 'YoU' and 'you' and 'YOU' are
  ## considered the same (the same one unique word) email. can only have 1 'you'.
  					uniqueness: { case_sensitive: false }
  # 
  has_secure_password
  validates :password, length: { minimum: 6 }

end


# NOW: A user will be created based on these requiements and be sent 
## to the database and saved under the db/schema.rb structure.