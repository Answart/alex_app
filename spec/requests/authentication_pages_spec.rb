# SOURCE: spec/requests/authentication_pages_spec.rb
# integration test (request spec) when signing in
# to use integration tests for the pages associated logged on cookies (Sessions resource)

require 'spec_helper'   # AKA /spec/spec_helper.rb

describe "Authentication" do
  subject { page }

  describe "signin page" do # AKA app/views/sessions/new.html.erb
  	before { visit signin_path }
  	let(:login) { "Sign in" } # need this as capybara has problem understanding buttons

    # if sign-in info is invalid when logging on ...
    describe "with invalid information" do
      before { click_button login }
      ## ... it should still have the Sign In title
      it { should have_title('Sign in') }
      ## ... it should have an error alert
      	# it { should have_selector('div.alert.alert-error', text: 'Invalid') } # OR: it { should have_error_message('Invalid') }  # referring to of spec/support/utilities.rb
      it { should have_error_message('Invalid') } # source: spec/support/utilities.rb
      ## ... it doesn't show the error message after going to another page
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    # if sign-in info is valid when logging on ...
    describe "with valid information" do
      ## ... ':user' now refers to Active Record object ':user' based on inputs
      ## and sends you to the :user's profile page
      let(:user) { FactoryGirl.create(:user) }
      ## ... it filled in these input fields which relate to user object in db
      before { valid_signin(user) } # referring to spec/support/utilities.rb
      	# OR: 
      	##before do
      	##  fill_in "Email",    with: user.email.upcase
      	##  fill_in "Password", with: user.password
      	##  click_button login # OR: "Sign in"
      	##end
      ## ... should show profile information
      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      ## ... should have 'sign out' available for user
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end
end