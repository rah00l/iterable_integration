# Example usage in a controller action
class EventsController < ApplicationController
  def track_event
    # Make a request to the Iterable API
    response = Net::HTTP.post(URI.parse('http://localhost:3000/api/events/track'), { eventName: 'Event A', userId: current_user.id }.to_json, 'Content-Type' => 'application/json')
    
    # Handle the response
    if response.code == '200'
      # Event tracked successfully
    else
      # Handle errors
    end
  end
end
