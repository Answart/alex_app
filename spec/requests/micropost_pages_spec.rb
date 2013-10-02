# SOURCE: spec/requests/micropost_pages_spec.rb

require 'spec_helper'

describe "Micropost pages" do

  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { "Post" }
  let(:login) { "Sign in" }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path } # start at the home page

    describe "with invalid information" do
      it "should not create a micropost" do
        expect { click_button post }.not_to change(Micropost, :count) # clicking the Post button doesn't increase amount of Microposts
      end
      describe "error messages" do
        before { click_button post } # before you click the post button
        it { should have_content('error') } # you should receive an error
      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" } # when a post is filled in
      it "should create a micropost" do
        expect { click_button post }.to change(Micropost, :count).by(1) # post count increases by 1
      end
    end
  end

  # Tests for the Microposts controller destroy action
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }
      it "should delete a micropost" do
      	# test for destroying microposts uses Capybara to click the “delete” link and expects the Micropost count to decrease by 1
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end