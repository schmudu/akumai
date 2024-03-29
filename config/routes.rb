Trio::Application.routes.draw do
  resources :datasets

  namespace :invites do
    get "show"
    get "signup"
    post "respond_signup"
  end
  
  match '/analytics',  to: 'analytics#index',    via: 'get'
  namespace :analytics do
    get "core_courses"
    get "student_data"
    get "students"
  end

  resources :invitations, except: :create do
    collection do
      post :address
      post :review
      post :confirm
      get :index_helper
    end
  end

  # templates for angular
  namespace :templates do
    get "core_course_checkbox"
    get "student_checkbox"
  end

  resources :programs
  resources :core_courses
  resources :mapped_courses
  match '/program_user_level', to:'programs#user_level', via: 'get'
  match '/dashboard',   to: 'users#dashboard',   via: 'get'
  devise_for :users, controllers: { registrations: "users/registrations" }
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
