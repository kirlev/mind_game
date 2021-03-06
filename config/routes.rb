MindGame::Application.routes.draw do

  get "set_language/english"

  get "set_language/hebrew"

  get "instructions/create"

  get "games/show"

  get "games/index"

  get "statistics/create"

root to: 'static_pages#home'

resources :games
resources :instructions
resources :statistics
resources :therapists
resources :patients do
  get 'show_details_to_therapist', :on => :member
end

resources :sessions, only: [:new, :create, :destroy]

#static pages
get '/help',    to: 'static_pages#help'
get '/about',   to: 'static_pages#about'
get '/contact', to: 'static_pages#contact'

#sign-up pages
get '/signup', to: 'therapists#new'
get '/patient_signup', to: 'patients#new'

#sign-in-out pages
get '/signin',  to: 'sessions#new'
get '/signout', to: 'sessions#destroy', via: :delete
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   get 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   get 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # get ':controller(/:action(/:id))(.:format)'
end
