Rails.application.routes.draw do

	get 'admin/dashboard'
	get 'admin/restore' 
	get 'admin/item'
	get 'admin/user'
	get 'admin/history'
	root 'pages#home'
	devise_for :users
end
