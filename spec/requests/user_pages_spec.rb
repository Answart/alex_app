# SOURCE: spec/requests/user_pages_spec.rb
# integration test (request spec) for user pages
# to use integration tests for the pages associated with the Users resource

require 'spec_helper'  # AKA /spec/spec_helper.rb

describe "User pages" do
  subject { page }

  describe "profile page" do # AKA app/views/users/show.html.erb
	# creates a User factory through 'let' and the FactoryGirl method supplied
	## by the Factory Girl gem which defines Active Record objects
	let(:user) { FactoryGirl.create(:user) }
	before { visit user_path(user) }

	it { should have_content(user.name) }
	it { should have_title(user.name) }
  end

  describe "signup page" do # AKA app/views/users/new.html.erb
    before { visit signup_path }
    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
    # let the symbol ':submit' refer to the when the button f.submit, called 
    ## "Create my account", is clicked
    let(:submit) { "Create my account" }
    # if 
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    # 
    describe "with valid information" do
      # insure all blanks are filled in so submit validly increases User count by 1
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "should create a user" do
      	# everytime a submit is clicked, it changes the User count by 1
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

end