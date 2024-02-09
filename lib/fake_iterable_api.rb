require 'net/http'
require 'uri'
require 'json'


class FakeIterableApi
	def initialize(app)
	  @app = app
	end

  def call(env)
  	if env['PATH_INFO'] == '/api/events/track'
	    # Implement logic to handle Iterable API requests and return fake responses
	    request = Rack::Request.new(env)

	    # Check if the request content type is JSON
	    if request.content_type == 'application/json'
	    	# Reset the request body so it can be read again
	    	env['rack.input'].rewind

	    	# Parse the JSON data from the request body
      	body = JSON.parse(request.body.read)

      	# Update the request parameters with the parsed JSON data
      	request.params.merge!(body)
	    end	
	    event_name = request.params['eventName']

	    if event_name == 'Event A'
	      # Logic for handling Event A
	      track_event(request)
	    elsif event_name == 'Event B'
	      # Logic for handling Event B and sending email notification
	      event_response = track_event(request)

	      email_response = if event_response[0] == 200
	        # Logic for handling Event B and sending email notification
	        send_email_notification
	      else
	      	send_email_notification(valid_request: false)
	      end

	      # Extract the "msg" part from the email response
	      email_msg = email_response.chomp('"').reverse.chomp('"').reverse # Remove surrounding quotes if present

	      # Extract the existing "msg" part from the event response body
	      event_msg = JSON.parse(event_response[2].first)["msg"]

	      # Merge the messages by appending them with a separator
	      merged_msg = "#{event_msg} - #{email_msg}"

	      # Update the "msg" part in the event response body with the merged message
	      event_response[2].first.gsub!(/"msg":"[^"]+"/, "\"msg\":\"#{merged_msg}\"")

	      event_response
	    else
	    	# Return an error response for unrecognized events
	    	invalid_event_response
	    end
	  else
	  	@app.call(env)
	  end
  end

  private

  def track_event(request)
  	event_name = request.params['eventName']

		if valid_api_key?(request) && required_parameters_present?(request)
      # Sample response for 200 OK
      success_response(event_name)
    elsif !valid_api_key?(request)
      # Sample response for 401 Unauthorized (Invalid API Key)
      unauthorized_response
      send_email_notification(valid_request: false) if event_name == 'Event B'
    else
      # Sample response for 400 Bad Request (Invalid Parameters)
      invalid_parameters_response
    end
  end

  def valid_api_key?(request)
    # Logic to check if the API key is valid
    # For simplicity, assuming the API key is present in request.params['apiKey']
    !request.params['apiKey'].nil? && request.params['apiKey'] == 'valid_api_key'
  end

  def success_response(event_name)
    status = 200
    headers = { 'Content-Type' => 'application/json' }

    # Sample response for 200 OK
    success_response = {
      "msg": "#{event_name} tracked successfully",
      "code": "Success",
      "params": {}
    }

    [status, headers, [success_response.to_json]]  # Return as array with body as a string
  end

  def unauthorized_response
    status = 401
    headers = { 'Content-Type' => 'application/json' }

    # Sample response for 401 Unauthorized (Invalid API Key)
    unauthorized_response = {
      "msg": "Invalid API key",
      "code": "BadApiKey",
      "params": {}
    }

    [status, headers, [unauthorized_response.to_json]]  # Return as array with body as a string
  end

  def invalid_parameters_response
    status = 400
    headers = { 'Content-Type' => 'application/json' }

    # Sample response for 400 Bad Request (Invalid Parameters)
    invalid_parameters_response = {
      "msg": "Invalid parameters",
      "code": "InvalidParameters",
      "params": {}
    }

    [status, headers, [invalid_parameters_response.to_json]]  # Return as array with body as a string
  end

  def invalid_event_response
    status = 400
    headers = { 'Content-Type' => 'application/json' }
		
		# Sample response for 400 Bad Request (Invalid event name)
    invalid_event_response = {
      "msg": "Invalid event name",
      "code": "InvalidEventName",
      "params": {}
    }

    [status, headers, [invalid_event_response.to_json]]  # Return as array with body as a string
  end

  def required_parameters_present?(request)
    # Check if the required parameters for Event A are present in the request
    request.params.include?('email') && request.params.include?('userId')
  end

  def send_email_notification(valid_request: true)
  	# Logic for sending email notification via Iterable API
  	# https://api.iterable.com/api/docs#email_target
  	# Send an email to an email address
		# POST /api/email/target
		# Construct the request
		uri = URI.parse('https://api.iterable.com/api/email/target')
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true # Enable SSL/TLS
		
		# Create the request
		request = Net::HTTP::Post.new(uri.request_uri)
		request['Content-Type'] = 'application/json'
		
		# Assuming the email parameters
		email_params = {
		  recipient_email: 'user@example.com',
		  subject: 'Your subject here',
		  body: 'Your email body here'
		}

		# Set the request body with email parameters
		  request.body = email_params.to_json
		  
		  # Make the request
		  response = http.request(request)

		  if valid_request
		    # Mock successful response for valid request
		    response_body = {
		      "msg" => 'Email sent successfully',
		      "code" => "Success",
		      "params" => {}
		    }
		  else
		    # Mock failure response for invalid request
		    response_body = {
		      "msg" =>'Failed to send email',
		      "code" => "Failed",
		      "params" => {}
		    }
		  end

		  response_body["msg"].to_json # Return the response body
  end
end
