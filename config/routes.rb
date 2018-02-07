Rails.application.routes.draw do

	get 'admin/dashboard'
	get 'admin/restore' 
	get 'admin/item'
	get 'admin/user'
	get 'admin/order'
	get 'admin/history'
	get 'admin/backup'
	root 'pages#home'
	devise_for :users
	resources :items do
		get :autocomplete_item_name, on: :collection
		post :import, on: :collection
	end
	get 'orders/:code', to: 'orders#show', as: 'order'
	post 'orders/new', to: 'orders#new'
	post 'order_details/new', to: 'order_details#new'
end
