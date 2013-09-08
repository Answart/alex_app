# This is used by Rails to encrypt session variables so that it is dynamically 
## generated rather than hard-coded

# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

require 'securerandom'

def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    # Use the existing token.
    File.read(token_file).chomp
  else
    # Generate a new token and store it in token_file.
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
  end
end

AlexApp::Application.config.secret_key_base = 'eed10d8bdb0da300c1d3df91fd35a4851049a3ba5d46551785c3f9e57c3d20e55047dc64070eccddb5e30dbb6672d9d82fb4f8af75dd9b2f954ce6fe4930bea2'
