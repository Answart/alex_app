# SOURCE: app/helpers/users_helper.rb
# so far helps the user's profile page at app/views/users/show.html.erb


module UsersHelper

  # return gravatar for: the user and the optional size parameter
  def gravatar_for(user, options = { size: 50 })
  	# Returns the Gravatar (http://gravatar.com/) for the given user based on their email.
  	# gravatar url based on MD5 through hexdigest method (hashing algorithm)
  	## of the user's email
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    # optional size parameter
    size = options[:size]
    # gravatar link will be the users gravatar which is in the specified size
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end