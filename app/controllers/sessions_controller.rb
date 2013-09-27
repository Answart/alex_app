# SOURCE: app/controllers/sessions_controller.rb
# SECOND step: specified action in the Sessions controller based on '/sessions' (from router)
## 1. identify HTTP request method (GET, POST, PATCH, DELETE)
## 2. what is URL (/signin, /sessions, signout)
## 3. which action in controller pairs with the URL (new, create, destroy)
## 4. send to model corresponding to the controller's URL/action pair
# FIFTH step:
## 1. receives info from database(via model) and manipulates its use via specified model/controller action
# SIXTH step:
## 1. provides info to 'app/views/' AKA specified View
## (EX: app/views/sessions/new.html.erb)
# SEVENTH step:
## 1. receives view which was converted froms content to HTML (Step 7)
## (view uses embedded Ruby to render the page as HTML)
# EIGTH step:
## 1. which is then returned by the controller to the browser for display
## (controller passes the HTML back to the browser)

# each 'def's main purpose is to modify information about users in the database


class SessionsController < ApplicationController

  # source: /sessions/new AKA app/views/sessions/new.html.erb
  # user log in page
  def new
  end

  # source: /sessions/new AKA app/views/sessions/new.html.erb
  # refers to user's profile page based on log in info
  def create
  	# the active user is the User object specified by the submitted email input (lowercased)
  	user = User.find_by(email: params[:session][:email].downcase) # user = User.find_by(email: params[:email].downcase) 
  	# if active user and inputed password correlate to the same User object ...
  	if user && user.authenticate(params[:session][:password]) # (set up to accept a hash from form_for method AKA [:sessions])
      ## ... sign the user in and redirect to the user's show page.
      sign_in user
      redirect_back_or user # OR: redirect_to user
  	else
      ## ... create an error message and re-render the signin form.
      # flash.now is specifically designed for displaying flash messages on rendered
      ## pages where its contents disappear as soon as there is an additional request
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # Destroying a session (user signout)
  def destroy
    sign_out
    redirect_to root_url
  end
end

