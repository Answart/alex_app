# SOURCE: spec/models/user_spec.rb
# User model validations using test-driven development; an initial spec for testing users
# ensures that the data model from the development database, db/development.sqlite3, is reflected in the test database, db/test.sqlite3.
# tests currently for: app/models/user.rb

require 'spec_helper' # AKA /spec/spec_helper.rb

describe User do

  # WHAT ITS DEALING WITH
  # 'before' runs the code inside the block before each example—in this case,
  ## creating a new @user instance variable using User.new and a valid initialization hash
  before do
    # @user makes whatever the @user is the default subject of the test example
    @user = User.new(name: "Example User", email: "user@example.com",
              password: "foobar", password_confirmation: "foobar")
  end
  
  # BASICS
  # the default subject of the test (which is @user),
  ## { @user } should be tested for the existence of... (each 'it')
  ## AKA: initialization hash for User.new
  subject { @user }
  # 'respond_to?' accepts a symbol and returns true if the object responds to the given method or attribute
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  # Ensure a User object has a password_digest column
  it { should respond_to(:password_digest) }
  # FYI: password attributes will be virtual—they will only exist temporarily in memory, and will not be persisted to the database
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  # to store a remember token equal to the user’s id to stay logged in (cookie)
  it { should respond_to(:remember_token) }
  # require a User object to respond to authenticate
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  # test for the user’s microposts attribute. 
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  # 'user.relationships' attribute test
  it { should respond_to(:relationships) }
  # 'user.followed_users' attribute test | user can see array of those they followed
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  # boolean method to test if one user is following another
  it { should respond_to(:following?) }
  # utility method so that we can write user.follow!(other_user)
  # we indicate with an exclamation point that an exception will be raised on failure.
  it { should respond_to(:follow!) }
  # all attributes for User should be valid to be an accepted User
  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it { should be_admin } # implies (via the RSpec boolean convention) that the user should have an admin? boolean method
  end

  # VALIDATIONS
  # 'describe' tells you the name of the error when you do a spec check
  # if the :name is blank, its an invalid attribute.
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  # if :name has a string.length of 51, its an invalid attribute.
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  # EMAIL:
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  # if :email address is invalid, its an invalid attribute
  describe "when email format is invalid" do
    it "should be invalid" do
      # the common invalid email forms:
      ## dont use: foo,com | 'at' instead of @ | more than 1 @ | symbols after the @
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        # if address is invalid...
        @user.email = invalid_address
        ## email becomes invalid
        expect(@user).not_to be_valid
      end
    end
  end

  # if :email address is valid, its a valid attribute
  describe "when email format is valid" do
    it "should be valid" do
      # the common valid email forms:
      ## uppercase, underscores, and compound domains;
      ## the standard corporate username first.last, with a two-letter top-level domain jp (Japan))
      ## along with several invalid forms
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        # if the address is valid, the email is valid
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  # if new email address is taken, :email is invaid
  describe "when email address is already taken" do
    # if a new user is created and saved with a dup email address...
    before do
      # make a user with the same email address as @user,
      ## which creates a new user as a duplicate with same attributes.
      user_with_same_email = @user.dup
      # save new user's email as uppercase, so all addresses can be compared as uppercase
      ## this would matter if the email was case sensitive (as of user.rb it is not).
      user_with_same_email.email = @user.email.upcase
      # Since we then save new user,
      ## the original @user has an email address that already exists in the database,
      user_with_same_email.save
    end
    # The rejection of duplicate email addresses.
    it { should_not be_valid }
    # NOW: the database will save a user record based on the first request,
    ##  and will reject the second save for violating the uniqueness constraint
  end
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  # if password and confirmation pass are nil, it is invalid
  describe "when password is not present" do
    before do
      # test the presence validation by setting both the password 
      # and its confirmation to a blank string
      @user = User.new(name: "Example User", email: "user@example.com",
        password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  # if password |= confirmation, both are invalid
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  # if (pass = pass conf) but has a .length of 5, its invalid
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  # two cases of password match and mismatch
  describe "return value of authenticate method" do
    # saves the user to the database so that it can be retrieved using 'find_by',
    ## which we accomplish using the 'let' method
    before { @user.save }
    # creates a ':found_user' variable whose value is equal to the result of 'find_by'
    let(:found_user) { User.find_by(email: @user.email) }
    # 'let' is a synonym for 'it', except it memoizes

    # when found_user.authenticate == @user.password
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
    # from now on, a variable called ':user_for_invalid_password' is when
    ## the ':found_user' 's authentication is classified as the string "invalid"
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      # it [i.e., the user] should not equal wrong user
      it { should_not eq user_for_invalid_password }
      # OVERALL: specify that user with invalid password should be false
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
  # test for a valid (nonblank) remember token
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  # Testing the order of a user’s microposts. 
  describe "micropost associations" do
    before { @user.save }
    # with let!, which forces the corresponding variable to come into existence immediately
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      # ordered newest first
      # to_a: converts @user.microposts from its default state (which happens to be an Active Record “collection proxy”) to a proper array appropriate for comparison with the one we constructed by hand
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    # Testing that microposts are destroyed when users are
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      # safety check to catch any errors should the to_a ever be accidentally removed
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        # expectation that the microposts don’t appear in the database
        # 'Micropost.where' returns an empty object if the record is not found instead of raising an exception, which is a little easier to test
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    # 
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  # 
  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end
    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end
    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }
      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
end

# RSpec boolean convention:
## whenever an object responds to a boolean method foo?, there is a corresponding test method called be_foo.
## EX: @user.valid?    ->   it "should be valid" do expect(@user).to be_valid end

# 'let' method provides a convenient way to create local variables inside tests
# 'let' 'memoizes' its value so that the first nested 'describe' block in Listing 
## 6.28 invokes 'let' to retrieve the user from the database using 'find_by',
## but the second 'describe' block doesn’t hit the database a second time.
# A 'memoized' function "remembers" the results corresponding to some set of specific inputs



# NOW: a test spec for the user model at app/models/user.rb