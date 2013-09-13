# 'Gem requirements for this app'
# '>= 4.0.0' installs the latest gem when you run bundle install
# '~> 4.0.0' installs updated gems representing minor point releases (e.g., from 4.0.0 to 4.0.1), but not major point releases (e.g., from 4.0 to 4.1).

source 'https://rubygems.org'
ruby '2.0.0'
#ruby-gemset=railstutorial_rails_4_0

gem 'rails', '4.0.0'
gem 'bootstrap-sass', '2.3.2.0' # bootstrap resource gem
gem 'bcrypt-ruby', '3.0.1' # state-of-the-art hash function called bcrypt to irreversibly encrypt the password to form the password hash

group :development, :test do
  gem 'sqlite3', '1.3.7'
  gem 'rspec-rails', '2.13.1' # rspec
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.1' # defines a domain-specific language in Ruby, in this case specialized for defining Active Record objects
  gem 'cucumber-rails', '1.4.0', :require => false # alternative for rspec
  gem 'database_cleaner', github: 'bmabey/database_cleaner' # cucumber's utility gem
end

gem 'sass-rails', '4.0.0' # css.scss
gem 'uglifier', '2.1.1' # handles file compression for the asset pipeline
gem 'coffee-rails', '4.0.0' # also needed by the asset pipeline
gem 'jquery-rails', '2.2.1' # jquery for rails
gem 'turbolinks', '1.1.1'
gem 'jbuilder', '1.0.2'

group :doc do
  gem 'sdoc', '0.3.20', require: false # don't require sdocs when documenting development
end

group :production do
  gem 'pg', '0.15.1' # 
  gem 'rails_12factor', '0.0.2' # 
end