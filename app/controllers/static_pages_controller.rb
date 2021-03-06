# SOURCE: app/controllers/static_pages_controller.rb
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

# each 'def's main purpose is to modify information about static pages in the database
class StaticPagesController < ApplicationController

  # source: '/'
  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      # creates a paginated feed of the relevant microposts for use in the view
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  # source: '/help'
  def help
  end

  def about
  end

  def contact
  end

  def sitemap
  end

  # asks the Static Pages model the browser will be sent to, to retrieve a list of 
  ## info the def requires from the database (step 3)
  #def index
  # => @users = User.all
  #end

end
