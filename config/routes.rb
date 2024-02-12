Rails.application.routes.draw do

  # post '/events/track_event', to: 'events#track_event'
  root 'events#index'

  # Route for the create_event action in the EventsController
  post '/events/create_event', to: 'events#create_event'
end
