# SOURCE: spec/requests/authentication_pages_spec.rb
# integration test (request spec) when signing in
# to use integration tests for the pages associated logged on cookies (Sessions resource)

require 'spec_helper'   # AKA /spec/spec_helper.rb

describe "Authentication" do
  subject { page }
  let(:login) { "Sign in" } # need this as capybara has problem understanding buttons

  describe "signin page" do # AKA app/views/sessions/new.html.erb
  	before { visit signin_path }
  	let(:login) { "Sign in" }

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
      ## ... should not show information
      it { should_not have_link('Profile')} # ,     href: user_path(user) 
      it { should_not have_link('Settings')} # ,    href: edit_user_path(user)
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
      #OR: before { sign_in user }
      ## ... should show profile information
      it { should have_title(user.name) }
      it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      ## ... should have 'sign out' available for user
      #describe "followed by signout" do
      #  before { click_link "Sign out" }
      #  it { should have_link('Sign in') }
      #end
    end
  end

  # Testing that the edit and update actions are protected.
  describe "authorization" do # AKA app/views/sessions/new.html.erb
    # if user is not logged in ...
    describe "for non-signed-in users" do
      # create an ActiveRecord object to be the symbol 'user'
      let(:user) { FactoryGirl.create(:user) }
      #let(:login) { "Sign in" }

      # A test for friendly forwarding. 
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button login #other says "Sign in"
        end
        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
          # Exercise 9.8: A test for forwarding to the default page after friendly forwarding.
          # a test to make sure that the friendly forwarding only forwards to the 
          ## given URL the first time. On subsequent signin attempts, the forwarding 
          ## URL should revert to the default (i.e., the profile page). 
          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button login
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.name)
            end
          end
        end
      end

      # 
      describe "in the Users controller" do
        # ... visiting the edit page redirects to Sign In page
        describe "visiting the edit page" do
          before { visit edit_user_path(user) } 
          it { should have_title('Sign in') }
        end
        # ... visiting the update page redirects to Sign In page
        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        # Testing that the index action is protected. 
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    # Exercise 9.6: Signed-in users have no reason to access the new and create 
    ## actions in the Users controller. Arrange for such users to be redirected to 
    ## the root URL if they do try to hit those pages
    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      # passing a user hash when POSTing, and using the no_capybara option on the 
      ## sign_in method, since get and post are not capybara methods and I think 
      ## RSpec doesn't behave as we might expect if we switch from capybara to 
      ## non-capybara methods within the same test.
      before { sign_in user, no_capybara: true  } # used because a user hash would only be needed if Rails actually carries out the create method, which is what we're trying to prevent.

      describe "using 'new' action" do
        before { get new_user_path }
        #specify { expect(response).to redirect_to(root_url) } # specify { response.should redirect_to(root_path) }
        specify { response.should redirect_to(root_path) }
        #it { should_not have_selector 'title', text: full_title('Sign Up') }
      end

      describe "using 'create' action" do
        before do
          @user_new = {name: "Example User", 
                   email: "user@example.com", 
                   password: "foobar", 
                   password_confirmation: "foobar"}
          post users_path, user: @user_new 
        end
        specify { response.should redirect_to(root_path) } # specify { expect(response).to redirect_to(root_path) }
        # it { should_not have_selector 'title', text: full_title('Sign Up') }
      end    
    end

    #describe "admin users" do
      ## Exercise 10.6.5 Modify the destroy action to prevent admin
      ## users from destroying themselves. (Write a test first.)
    #  it "cannot destroy themselves" do
    #    admin = Factory(:user, :email => "admin@example.com", :admin => true)
    #    test_sign_in(admin)
    #    User.should_receive(:find).with(admin).and_return(admin)
    #    delete :destroy, :id => admin
    #    response.should redirect_to(users_path)
    #    flash[:error].should =~ /Admin suicide warning/i
    #  end
    #end
  end
end