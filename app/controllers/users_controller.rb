# SOURCE: app/controllers/users_controller.rb
# SECOND step: specified action in the Users controller based on '/users' (from router)
## 1. identify HTTP request method (GET, POST, PATCH, DELETE)
## 2. what is URL (/users/new, /users, /users/1, /users, /users/1) (note duplicate URLs)
## 3. which action in controller pairs with the URL (new, index, show, create, update, edit, destroy, etc)
## 4. send to model corresponding to the controller's URL/action pair
# FIFTH step:
## 1. receives info from database(via model) and manipulates its use via specified model/controller action
# SIXTH step:
## 1. provides info to 'app/views/' AKA specified View
## (EX: app/views/users/index.html.erb)
# SEVENTH step:
## 1. receives view which was converted froms content to HTML (Step 7)
## (view uses embedded Ruby to render the page as HTML)
# EIGTH step:
## 1. which is then returned by the controller to the browser for display
## (controller passes the HTML back to the browser)

# each 'def's main purpose is to modify information about users in the database

class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  #before_filter :existing_user,   only: [:new, :create]
  #before_filter :authenticate,   only: [:index,:show,:edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  # Exercise 9.6: 
  before_filter :signed_in_user_filter, only: [:new, :create]

  # asks the User model the browser will be sent to, to retrieve a list of 
  ## all the users from the database (step 3)
  def index
    @users = User.paginate(page: params[:page])
  end

  # source: /users/(:id) (EX: /users/1, /users/56353471) AKA app/views/users/show.html.erb
  # user profile page
  def show
  	# the show action for the Users controller which uses the 'find' 
  	## method on the User model to retrieve the user from the database
    @user = User.find(params[:id])
    # '.paginate' works through the microposts association, reaching into the microposts table and pulling out the desired page of microposts
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # source: /users/new AKA app/views/static_pages/new.html.erb
  # user registration page
  def new
  	# the '@user' the /new page uses will be a brand new User
    @user = User.new
  end

  # /users/1/edit or /users/2342960/edit or /users/:id/edit
  def edit
    # @user = User.find(params[:id]) # <-- we can delete this because the before filter correct_user now defines @user variable
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      #sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  #def destroy
  #  User.find(params[:id]).destroy
  #  flash[:success] = "User destroyed."
  #  redirect_to users_url
  #end
  # Exercise 9.9
  def destroy
    @user = User.find(params[:id])
    #@admin = 
    if current_user?(@user)
      redirect_to users_url, notice: "You can't destroy yourself."
    else
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  # source: there is not (nor should there be) a view template corresponding to the create action
  # for when f.submit has been clicked on the new page
  def create
    # used to be 'params[:user]' but changed to the private 'user_params' for security reasons
    @user = User.new(user_params)
    # if submit is valid and is saved ...
    if @user.save
      sign_in @user
      # Add a flash message to user signup since its successful
      flash[:success] = "Welcome to the Alex App!"
      # Redirect to the newly created user’s profile (show page)
      redirect_to @user
    # else keep on user registration page (new page)
    else
      #flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # 
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  # Using 'private' means the following will only be used internally by the 
  ## Users controller and need not expose the following methods to external users via the web
  private
  	# ensures submitted data returns an appropriate initialization hash
  	# Prohibits any user of the site to gain administrative access by 
  	## including admin=’1’ in their web request
    def user_params
      # :user only permits these attributes...
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters apply to every action in a controller (in this case only for edit and update)
    #def signed_in_user
    #  unless signed_in?
    #    store_location
    #    redirect_to signin_url, notice: "Please sign in."
    #  end
      #- redirect_to signin_url, notice: "Please sign in." unless signed_in?
    #end -> MOVED TO: app/helpers/sessions_helper.rb

    #def authenticate
    #  deny_access unless signed_in?
    #end

    # 
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Exercise 9.9: A before filter restricting the destroy action to admins. 
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    # Exercise 9.6: 
    def signed_in_user_filter
      if signed_in?
        redirect_to root_path, notice: "Already logged in"
      end
    end

end
