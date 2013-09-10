# 'Gem requirements for this app'
# '>= 4.0.0' installs the latest gem when you run bundle install
# '~> 4.0.0' installs updated gems representing minor point releases (e.g., from 4.0.0 to 4.0.1), but not major point releases (e.g., from 4.0 to 4.1).


source 'https://rubygems.org'
ruby '2.0.0'
#ruby-gemset=railstutorial_rails_4_0

gem 'rails', '4.0.0'
gem 'bootstrap-sass', '2.3.2.0'
# state-of-the-art hash function called bcrypt to irreversibly encrypt the password to form the password hash
gem 'bcrypt-ruby', '3.0.1'

group :development, :test do
  gem 'sqlite3', '1.3.7'
  gem 'rspec-rails', '2.13.1'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  # defines a domain-specific language in Ruby, in this case specialized for defining Active Record objects
  gem 'factory_girl_rails', '4.2.1'
end

gem 'sass-rails', '4.0.0'
gem 'uglifier', '2.1.1' # handles file compression for the asset pipeline
gem 'coffee-rails', '4.0.0' # also needed by the asset pipeline
gem 'jquery-rails', '2.2.1'
gem 'turbolinks', '1.1.1'
gem 'jbuilder', '1.0.2'

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end