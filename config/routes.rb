Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  # post '/events/track_event', to: 'events#track_event'
  root 'events#index'

  # Route for the create_event action in the EventsController
  post '/events/create_event', to: 'events#create_event'
end
