Footoo::Application.routes.draw do


  devise_for :users, path_names: { sign_in: "login", sign_out: "logout"}
  root to: 'albums#index'

  match 'albums/:album_id/slides/(:ids)', to: 'slides#destroy', via: :delete, as: :multi_slides_delete
  match 'albums/:album_id/slides/(:ids)', to: 'slides#move', via: [:patch, :put], as: :multi_slides_move

  resources :albums, except: :show do
    resources :slides, shallow: true, except: [:destroy, :patch, :put]            
  end

  get 'albums/:album_id', to: 'slides#index'
  
  resources :trash, only: [:index, :show, :destroy] do
    match 'all', to: 'trash#destroy_all', via: :delete, on: :collection
    match 'all', to: 'trash#restore_all', via: :patch, on: :collection
    match 'all', to: 'trash#restore_all', via: :put, on: :collection
  end
  match 'trash/:id', to: 'trash#restore', via: :patch
  match 'trash/:id', to: 'trash#restore', via: :put


  # require 'sidekiq/web'
  # mount Sidekiq::Web => '/sidekiq'

  authenticate :user do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

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
