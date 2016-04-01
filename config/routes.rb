Rails.application.routes.draw do
  resources :orders
  devise_for :admins do
    delete '/admins/sign_out' => 'devise/sessions#destroy'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'company_detail#index'


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

  get 'show_users/showusers' => 'show_users#showusers'

  get 'company_detail/generate_license_for_Company_user' => 'company_detail#generate_license_for_Company_user'

  get 'company_detail/save_license_cost' => 'company_detail#save_license_cost'

  get 'company_detail/get_license_cost' => 'company_detail#get_license_cost'

  namespace :api do
    namespace :v1 do
      resources :company


      post 'company/get_valid_days_left' => 'company#get_valid_days_left'
      post 'company/create' => 'company#create'
      # post 'company/create_comment' => 'company#create_comment'
      post 'company/add_comment' => 'company#add_comment'
      post 'users/create' => 'users#create'
      get 'company/get_comment' => 'company#get_comment'
     
      put 'company/comment_update' => 'company#comment_update', :via => [:put, :patch]
      patch 'company/comment_update' => 'company#comment_update', :via => [:put, :patch]
    end
  end
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
