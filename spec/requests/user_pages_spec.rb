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
    
    # a page with invalid info on f.submit ...
    describe "with invalid information" do
      ## ... should not increase User count
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      ## ... should now show the following content:
      describe "after submission" do
        before { click_button submit }
        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end

    # a page with valid info on f.submit ...
    describe "with valid information" do
      ## ... has filled in these input fields which replaces default info
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      ## ... changed the User count by 1
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      ## ... identified the new :user by email and redirected to profile page 
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name) }
        # contain particular CSS classes along with specific HTML tags
        it { should have_selector('div.alert.alert-success', text: 'Welcome') } # OR: it { should have_alert_message('Welcome') }
      end
      ## ... has a user successfully signed in
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') } # OR: it { should have_alert_message('Welcome') }
      end
    end
  end

end