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

# a custom RSpec matcher for error messages
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

# a custom RSpec matcher for alert messages (cant get to work)
RSpec::Matchers.define :have_alert_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end

# custom matcher for identifying buttons and links
RSpec::Matchers::define :have_link_or_button do |text|
  match do |page|
    Capybara.string(page.body).has_selector?(:link_or_button, text: text)
  end
  #then type: expect(page).to have_link_or_button('Login')
end