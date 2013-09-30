# SOURCE: spec/requests/user_pages_spec.rb
# integration test (request spec) for user pages
# to use integration tests for the pages associated with the Users resource

require 'spec_helper'  # AKA /spec/spec_helper.rb

describe "User pages" do
  subject { page }
  let(:login) { "Sign in" }
  let(:savechanges) { "Save changes" }
  let(:signup) { "Create my account" }
  let(:user) { FactoryGirl.create(:user) } # AKA spec/factories.rb

  describe "index" do
  	#let(:user) { FactoryGirl.create(:user) } # AKA spec/factories.rb
    before(:each) do
      sign_in user
      visit users_path
    end
    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }
      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        it { should have_link('delete', href: user_path(User.first)) }
        
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do # AKA app/views/users/show.html.erb
	# creates a User factory through 'let' and the FactoryGirl method supplied
	## by the Factory Girl gem which defines Active Record objects
	  #let(:user) { FactoryGirl.create(:user) }
    # 
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
	  before { visit user_path(user) }
	  it { should have_content(user.name) }
	  it { should have_title(user.name) }

    # test for showing microposts on the user show page
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      # count the microposts with the given user_id
      it { should have_content(user.microposts.count) }
    end
  end

  # /create action
  describe "signup page" do # AKA app/views/users/new.html.erb
    before { visit signup_path }
    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
    # let the symbol ':signup' refer to the when the button f.submit, called 
    ## "Create my account", is clicked
    #let(:signup) { "Create my account" }

    # a page with invalid info on f.submit ...
    describe "with invalid information" do
      ## ... should not increase User count
      it "should not create a user" do
        expect { click_button signup }.not_to change(User, :count)
      end
      ## ... should now show the following content:
      describe "after submission" do
        before { click_button signup }
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
        fill_in "Confirm Password", with: "foobar"
      end
      ## ... changed the User count by 1
      it "should create a user" do
        expect { click_button signup }.to change(User, :count).by(1)
      end
      ## ... identified the new :user by email and redirected to profile page 
      describe "after saving the user" do
        before { click_button signup }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name) }
        # contain particular CSS classes along with specific HTML tags
        it { should have_selector('div.alert.alert-success', text: 'Welcome') } # OR: it { should have_alert_message('Welcome') }
      end
      ## ... has a user successfully signed in
      describe "after saving the user" do
        before { click_button signup }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') } # OR: it { should have_alert_message('Welcome') }
      end
    end
  end

  # /edit action
  describe "edit" do # AKA app/views/users/edit.html.erb
    #let(:user) { FactoryGirl.create(:user) }
    #before { visit edit_user_path(user) }
    #let(:savechanges) { "Save changes" }
    #let(:login) { "Sign in" }
    before do # Adding a signin step to the edit and update tests.
      sign_in user
      visit edit_user_path(user)
    end
    
    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end
    describe "with invalid information" do
      before { click_button savechanges }
      it { should have_content('error') }
    end
    # submitting on the edit page with valid info means ...
    describe "with valid information" do
      ## ... name input is called 'new_name'
      let(:new_name)  { "New Name" }
      ## ... email input is called 'new_email'
      let(:new_email) { "new@example.com" }
      #before { valid_savechange(user) } # referring to spec/support/utilities.rb
      ## ... inputs are filled in with valid info
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button savechanges
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      ## ... reloads user variable from the test database using
      ## user.reload, then verifies that the user’s new name and
      ## email match the new values
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    # verify that the admin attribute isn’t editable through the web
    # Be sure: get Red first, then Green. (Hint: Your first step 
    ## should be to add admin to the list of permitted parameters in user_params.
    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end