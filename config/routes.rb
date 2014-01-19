Trio::Application.routes.draw do
  #invitations
  match '/invite_users/review',   to: 'invitations#review_invitations',   via: 'post', as: :invite_users_review
  match '/invite_users/type',   to: 'invitations#invite_users_type',   via: 'get', as: :invite_users_type
  match '/invite_users/address',   to: 'invitations#invite_users_address',   via: 'post', as: :invite_users_address
  match '/invite_users/cancel',   to: 'invitations#cancel',   via: 'get'
  match '/send_invitations',   to: 'invitations#send_invitations',   via: 'post'
  
  resources :invitations
  resources :programs
  match '/program_user_level', to:'programs#user_level', via: 'get'
  match '/dashboard',   to: 'users#dashboard',   via: 'get'
  devise_for :users
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'  
  match '/help',    to: 'static_pages#help',    via: 'get'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'

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
