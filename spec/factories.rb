# SOURCE: spec/factories.rb
# relying on Ruby blocks and custom methods to define the attributes 
## of the desired object
# code needed to make a User factory

FactoryGirl.define do
  # tells Factory Girl the subsequent definition is for a User model object
  factory :user do
    name     "Michael Hartl"
    email    "mhartl@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end