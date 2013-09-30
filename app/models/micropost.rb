# SOURCE: app/models/micropost.rb
# 

class Micropost < ActiveRecord::Base
  belongs_to :user
  # to get the ordering test to pass (order the 'created_at' in descending order)
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
end