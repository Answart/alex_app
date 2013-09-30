# SOURCE: app/models/user.rb
# THIRD step:
## 1. receive action based on controller's URL/action pair in step 2
# FOURTH STEP:
## 1. retrieve info from database (/db) based on model's structure

# code for the User model for when a potential User is created.
# a created User is an accepted User because when it has the following...
# if a blank User is created, alex_app creates one based on these stats (ids with nil values).

class User < ActiveRecord::Base

  # dependent microposts (i.e., the ones belonging to the given user) to be destroyed when the user itself is destroyed
  has_many :microposts, dependent: :destroy

  # make sure that the email address is all lower-case before it gets
  ## saved to the database because not all database adapters
  ## use case-sensitive indices
  # sets the user’s email address to a lower-case version of its current value
  before_save { self.email = email.downcase }
  # run this method before saving the user (method is defined privately)
  before_create :create_remember_token

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

  # 
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # A preliminary implementation for the micropost status feed
  def feed
    # Ensures that id is properly escaped before being included in the underlying SQL query, thereby avoiding a serious security hole called SQL injection.
    Micropost.where("user_id = ?", id)
  end

  private
    # def method assigns to one of the user attributes ('self' keyword) which
    ## ensures that assignment sets the user’s remember_token, and as a result
    ## it will be written to the database along with the other attributes when
    ## the user is saved
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end


# NOW: A user will be created based on these requiements and be sent 
## to the database and saved under the db/schema.rb structure.