# Example usage in a controller action
class EventsController < ApplicationController
  require 'net/http'
  require 'json'

  def index
  end

# This method is for creating an event by interacting with external services or the Fake API Server in our case.
# It sends a request to the Fake API Server with event details such as eventName, email, userId, and apiKey.
# If the request is successful, it renders a success message; otherwise, it renders an error message.
# Note: Calling the Fake Iterable Server API from this action may result in Net::HTTP timeout errors.
  def create_event
    # This method is for create an event by interacting with external services or the Fake API Server in our case
    # "eventName": "Event A", "email": "user@example.com", "userId": "123", "apiKey": "valid_api_key"
    # curl -X POST -H "Content-Type: application/json" -d '{"eventName": "Event A", "email": "user@example.com", "userId": "123", "apiKey": "valid_api_key"}' http://localhost:3000/events/create_event

    event_name = params[:eventName]
    email = params[:email]
    user_id = params[:userId]
    api_key = params[:apiKey]

    # Validate presence of required parameters
    if event_name.blank? || email.blank? || user_id.blank? || api_key.blank?
    render json: { error: 'Missing required parameters' }, status: :bad_request
    return
    end

    # Send request to Fake API Server
    response = send_request_to_fake_api_server(event_name, email, user_id, api_key)

    # Render response based on Fake API Server's response
    if response.code == '200'
    render json: { message: "#{event_name} created successfully" }, status: :ok
    else
    render json: { error: "Failed to create #{event_name}" }, status: :unprocessable_entity
    end
  end

  private


# This method sends a request to the Fake API Server (Fake Iterable Server) with event details.
# It constructs the request using Net::HTTP and sends it to the specified URI.
# Returns: Net::HTTPResponse object representing the server's response.
  def send_request_to_fake_api_server(event_name, email, user_id, api_key)
    uri = URI.parse("#{request.base_url}/api/events/track")
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')

    request.body = {
      eventName: event_name,
      email: email,
      userId: user_id,
      apiKey: api_key
    }.to_json

    http.request(request)
  end
end

