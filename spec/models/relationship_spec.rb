# SOURCE: spec/models/relationship_spec.rb
# Testing Relationship creation and attributes. 

require 'spec_helper'

describe Relationship do

  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  # establish the association between users and relationships
  # user associationcode : a relationshop is when a follower (primary key) builds association with the followed (foreign keys)
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }

  # Testing the user/relationships 'belongs_to' association from app/models/relationship.rb
  describe "follower methods" do
    # a relationship belongs_to both a follower and a followed user 
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should eq follower }
    its(:followed) { should eq followed }
  end

  # Cannot have relationship with only one present
  describe "when followed id is not present" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end
  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end
end