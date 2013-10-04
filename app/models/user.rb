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
  # 'foreign key': An id used in this manner to connect two database tables
  ## Rails expects a foreign key of the form <class>_id, where <class> is the lower-case version of the class name
  # foreign key for a User model object is user_id, although we are still dealing 
  ## with users, they are now identified with the foreign key follower_id, so we 
  ## have to tell that to Rails
  # destroying a user should also destroy that user’s relationships, dependent: :destroy is added to the association
  # foreign keys from the corresponding symbols (follower_id from :follower | followed_id from :followed)
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy # User(primary key) has many relationships - where it identifies as the 'follower_id' in the table
  # assembles an array using the followed_id in the relationships table.
  # :source parameter tells Rails the source of the followed_users array is the set of followed ids.
  # EX: ':followed' is source of 'followed_users' array AKA individual tables identifying each followed's info
  # :relationships, made possible by 'let' in spec/models/relationship_spec.rb
  has_many :followed_users, through: :relationships, source: :followed # User/follower has many followeds/followed_ids illustrated under the :followed array of user.followed_users
  has_many :reverse_relationships, foreign_key: "followed_id", # User(primary key) has many relationships - where it identifies as the 'followed_id' in the table
                                   class_name:  "Relationship", # based on the relationship class
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower # User/followed has many followers/follower_ids illustrated under the :follower array of user.followers

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
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
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