# SOURCE: spec/requests/static_pages_spec.rb
# integration test (request spec) for static pages

require 'spec_helper'   # AKA /spec/spec_helper.rb

describe "Static pages" do
  subject { page }    # page is a variable supplied by Capybara
  # let(:base_title) { "Ruby on Rails Tutorial Alex App" }
  let(:login) { "Sign in" }
  
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

    # rendering the feed on the Home page
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          # (Note that the first # in li##{item.id} is Capybara syntax for a CSS id, whereas the second # is the beginning of a Ruby string interpolation #{}.)
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      # Testing the following/follower statistics on the Home page.
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
        # the following and follower counts appear on the page, together with the right URLs
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      # Exercise 10.1 : Testing pluralized sidebar
      it "should pluralize sidebar feed header" do # AKA app/views/shared/_user_info.html.erb
        #page.should have_selector(‘section h1′, text: user.name) # didnt like ‘section h1′
        #page.should have_selector(‘section span’, text: pluralize(Micropost.count.to_s, “micropost”)) # didnt like ‘section span’
        #expect { pluralize(current_user.microposts.count, "micropost") } # works
        expect(page).to have_content("micropost".pluralize(user.feed.count))
        #page.should have_selector('section span', text: view.pluralize(Micropost.count.to_s, "micropost"))  # didnt like 'view.'
      end

      # Exercise 10.2: micropost pagination
      describe "pagination" do
        it "should paginate the feed" do
          30.times { FactoryGirl.create(:micropost, user: user, content: "Consectetur adipiscing elit") }
          visit root_path
          page.should have_selector("div.pagination")
        end
      end
    end
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