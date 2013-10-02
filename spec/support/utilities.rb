# SOURCE: spec/support/utilities.rb
# adding methods to decouple the tests from the implementation

include ApplicationHelper # AKA spec/helpers/application_helper_spec.rb

# to replace the 'let(:base_title) { "Ruby on Rails Tutorial Alex App" }' in static_pages_spec.rb
##def full_title(page_title)
##  base_title = "Ruby on Rails Tutorial Alex App"
##  if page_title.empty?
##    base_title
##  else
##    "#{base_title} | #{page_title}"
##  end
##end

# a helper method
def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button login
end

#def valid_signin(admin)
#  fill_in "Email",    with: admin.email
#  fill_in "Password", with: admin.password
#  click_button login
#end


# a custom RSpec matcher for error messages
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message) # to write: it { should have_error_message('Invalid') }
  end
end

# a custom RSpec matcher for alert messages (cant get to work)
RSpec::Matchers.define :have_success_message do |message|
    match do |page|
        page.should have_selector('div.alert.alert-success', text: message)
    end
end

# custom matcher for identifying buttons and links
#RSpec::Matchers::define :have_link_or_button do |text|
#  match do |page|
#    Capybara.string(page.body).has_selector?(:link_or_button, text: text)
#  end
  #then type: expect(page).to have_link_or_button('Login')
#end

# sign in helper to visit login page and submit valid info
def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara as well.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button login
  end
end

# method for saving changes to profile (/edit page)
def valid_savechange(user)
  fill_in "Name",             with: new_name
  fill_in "Email",            with: new_email
  fill_in "Password",         with: user.password
  fill_in "Confirm Password", with: user.password
  click_button savechanges
end