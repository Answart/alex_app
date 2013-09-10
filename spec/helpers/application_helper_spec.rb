# SOURCE: spec/helpers/application_helper_spec.rb
# used in spec/support/utilities.rb

require 'spec_helper' # AKA spec/spec_helper.rb

describe ApplicationHelper do

  describe "full_title" do
    it "should include the page title" do
      expect(full_title("foo")).to match(/foo/)
    end

    it "should include the base title" do
      expect(full_title("foo")).to match(/^Ruby on Rails Tutorial Alex App/)
    end

    it "should not include a bar for the home page" do
      expect(full_title("")).not_to match(/\|/)
    end
  end
end