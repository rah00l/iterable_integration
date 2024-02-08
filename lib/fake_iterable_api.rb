class FakeIterableApi
	def initialize(app)
	  @app = app
	end

  def call(env)
    
  	if env['PATH_INFO'] == '/api/events/track'
	    # Implement logic to handle Iterable API requests and return fake responses
	    status = 200
	    headers = { 'Content-Type' => 'application/json' }
	    body = { success: true, message: 'Event tracked successfully' }.to_json

	    [status, headers, [body]]  # Return as array with body as a string
	  else
	  	@app.call(env)
	  end
  end
end
