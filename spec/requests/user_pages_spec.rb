# SOURCE: spec/requests/user_pages_spec.rb
# integration test (request spec) for user pages


# AKA /spec/spec_helper.rb
require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

end