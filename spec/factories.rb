# SOURCE: spec/factories.rb
# relying on Ruby blocks and custom methods to define the attributes 
## of the desired object
# code needed to make a User factory

FactoryGirl.define do
  # tells Factory Girl the subsequent definition is for a User model object
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
  # a micropost factory to construct microposts in the User model test
  factory :micropost do
    content "Lorem ipsum"
    # tells Factory Girl about micropost’s associated user just by including a user in the definition of the factory
    user
  end
end