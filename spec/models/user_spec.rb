# SOURCE: spec/models/user_spec.rb
# User model validations using test-driven development; an initial spec for testing users
# ensures that the data model from the development database, db/development.sqlite3, is reflected in the test database, db/test.sqlite3.
# tests currently for: app/models/user.rb

require 'spec_helper'

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
  # all attributes for User should be valid to be an accepted User
  it { should be_valid }
  # require a User object to respond to authenticate
  it { should respond_to(:authenticate) }

  
  # VALIDATIONS
  # 'describe' tells you the name of the error when you do a spec check
  
  # if the :name is blank, its an invalid attribute.
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  # if the :email is blank, its an invalid attribute. 
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  # if :name has a string.length of 51, its an invalid attribute.
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
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