# SOURCE: spec/controllers/relationships_controller_spec.rb

require 'spec_helper'

describe RelationshipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  before { sign_in user, no_capybara: true }

  # Tests for the Relationships controller responses to Ajax requests.
  #  xhr method (for “XmlHttpRequest”) to issue an Ajax request; compare to the get, post, patch, and delete methods used in previous tests
  describe "creating a relationship with Ajax" do

    it "should increment the Relationship count" do
      expect do
        xhr :post, :create, relationship: { followed_id: other_user.id }
      end.to change(Relationship, :count).by(1)
    end
    it "should respond with success" do
      xhr :post, :create, relationship: { followed_id: other_user.id }
      expect(response).to be_success
    end
  end

  # Tests for the Relationships controller responses to Ajax requests.
  #  xhr method (for “XmlHttpRequest”) to issue an Ajax request; compare to the get, post, patch, and delete methods used in previous tests
  describe "destroying a relationship with Ajax" do
    before { user.follow!(other_user) }
    let(:relationship) { user.relationships.find_by(followed_id: other_user) }

    it "should decrement the Relationship count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end
    it "should respond with success" do
      xhr :delete, :destroy, id: relationship.id
      expect(response).to be_success
    end
  end
end