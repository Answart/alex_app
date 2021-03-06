# SOURCE: config/routes.rb
# FIRST step: browser requests a URL like '/users/new'
## 1. identifies the router's URL/action pair
## 2. dispatches to the proper controller action based on the URL
## (EX: the new action in app/controllers/users_controller.rb)

AlexApp::Application.routes.draw do
  # so the REST-style URL will work
  # it doesn’t just add a working /users/1 URL; it endows our sample 
  ## application with all the actions needed for a RESTful Users resource
  ## along with a large number of named routes (Section 5.3.3) for generating user URLs
  resources :users do
    # Adding following and followers actions to the Users controller. 
    member do
      get :following, :followers
    end
  end
  resources :sessions,      only: [:new, :create, :destroy]
  resources :microposts,    only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy] # Adding the routes for user relationships
  # match '/',      to: 'static_pages#home',    via: 'get'
  root 'static_pages#home'

  # matches a GET request for '/about' and routes it to the about action in
  ## StaticPages controller
  match "/help",    to: 'static_pages#help',    via: 'get'
  match "/about",   to: 'static_pages#about',   via: 'get'
  match "/contact", to: 'static_pages#contact', via: 'get'
  match "/sitemap", to: 'static_pages#sitemap', via: 'get'

  # /signup routes to /new via Users Controller
  match '/signup',  to: 'users#new',            via: 'get'

  # routes via Sessions Controller
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
