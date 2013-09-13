# SOURCE: app/helpers/sessions_helper.rb
# a module facility for packaging functions together and including them 
## in multiple places, for the authentication functions

module SessionsHelper

   # actual sign in method
  def sign_in(user)
  	# place a (newly created) remember token ...
    remember_token = User.new_remember_token
    ## ...  as a cookie on the user’s browser ... (.permanent means 20 years)
    cookies.permanent[:remember_token] = remember_token
    ## ... save the encrypted token to the database ... 
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    ## ... set current user = to active user
    self.current_user = user

    # (use the token to find the user record in the database as the
    ## user moves from page to page)
  end

  # A user is signed in if active user |= nil
  def signed_in?
    !current_user.nil?
  end

  # defines a method 'current_user=' expressly designed to handle assignment to 'current_user'
  def current_user=(user)
    @current_user = user
  end

  # to set the @current_user instance variable to the user corresponding to
  ## the remember token, but only if @current_user is undefined
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    # if user happens to be undefined, user can be recognized by its token
    # '||=' is the same as using '+=' in Java
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  # 'sign out' method
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
end