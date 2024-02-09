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
	      track_event_a
	    elsif event_name == 'Event B'
	      # Logic for handling Event B and sending email notification
	      track_event_b_and_send_notification
	    end
	  else
	  	@app.call(env)
	  end
  end

  private

  def track_event_a
  	# Logic for tracking Event A
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

  	[status, headers, [body]]  # Return as array with body as a string
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
  end
end
