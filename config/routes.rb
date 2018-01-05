Rails.application.routes.draw do

	get 'admin/dashboard'
	get 'admin/restore' 
	get 'admin/item'
	get 'admin/user'
	get 'admin/history'
	root 'pages#home'
	devise_for :users
	resources :items do
		get :autocomplete_item_name, on: :collection
	end
	get 'orders/:code', to: 'order#show', as: 'order'
	post 'orders/new', to: 'orders#new'
	post 'order_details/new', to: 'order_details#new'
end
