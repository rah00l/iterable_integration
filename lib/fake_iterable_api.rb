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
	      track_event(request)
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

  def required_parameters_present?(request)
    # Check if the required parameters for Event A are present in the request
    request.params.include?('email') && request.params.include?('userId')
  end

  def track_event_b_and_send_notification
  	# Logic for tracking Event B
  	status = 200
  	headers = { 'Content-Type' => 'application/json' }
  	body = {
  	  "msg": "Success",
  	  "code": 200,
  	  "params": {
  	    "successCount": 1,
  	    "failureCount": 0
  	  }
  	}.to_json

  	# Logic for sending email notification via Iterable API
  	# Assuming the correct endpoint is '/api/email/target'
  	send_email_notification

  	[status, headers, [body]]  # Return as array with body as a string
  end

  def send_email_notification
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
		  
		  # Mock the response (replace this with actual response parsing logic if needed)
		  response_body = {
		    msg: 'Email sent successfully',
		    code: 200,
		    params: {
		      emailId: 'user@example.com',
		      messageId: 'unique_message_id'
		    }
		  }.to_json
		  
		  response_body # Return the response body
  end
end
