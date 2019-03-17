Rails.application.routes.draw do
  post '/file', to: 'resources#create'
  get '/files', to: 'resources#index'
  get '/files/:tag_search_query/:page', to: 'resources#search'
end
