Basic::Application.routes.draw do
	root :to => 'demo#index'
	get '/resources', to: 'demo#index'
	get 'pdfs', to: 'demo#pdfs'
	get 'images', to: 'demo#images'
	get 'new', to: 'demo#new'
	post '/new_upload', to: 'demo#new_upload'
end
