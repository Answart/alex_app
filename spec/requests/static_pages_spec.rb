# SOURCE: spec/requests/static_pages_spec.rb
# integration test (request spec) for static pages

require 'spec_helper'   # AKA /spec/spec_helper.rb

describe "Static pages" do
  subject { page }    # page is a variable supplied by Capybara
  # let(:base_title) { "Ruby on Rails Tutorial Alex App" }
  
  # any { page } with this "quote" should include the following content:
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    # refers to: spec/support/utilities.rb or spec/helpers/application_helper_spec.rb
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    it_should_behave_like "all static pages"

    let(:heading)    { 'Alex App' }
    let(:page_title) { '' }
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }
    it_should_behave_like "all static pages"

    let(:heading)    { 'Help' }
    let(:page_title) { '' }
  end

  describe "About page" do
    before { visit about_path }
    it_should_behave_like "all static pages"

    let(:heading)    { 'About Us' }
    let(:page_title) { '' }
  end

  describe "Contact page" do
    before { visit contact_path }
    it_should_behave_like "all static pages"

    let(:heading)    { 'Contact' }
    let(:page_title) { '' }
  end

  describe "Site Map page" do
  	before { visit sitemap_path }
  	it_should_behave_like "all static pages"

  	let(:heading)    { 'Site Map' }
    let(:page_title) { '' }
  end

  it "should have the right links on the layout" do
    visit root_path
    # header
    click_link "alex app"
    expect(page).to have_content('Welcome to the Alex App')
    click_link "Home"
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    #click_link "Sign in"
    # container
    #click_link "Sign up now!"
    #expect(page).to have_title(full_title('Sign up'))
    # footer
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Site Map"
    expect(page).to have_title(full_title('Site Map'))
  end

end