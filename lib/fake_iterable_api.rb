class FakeIterableApi
	def initialize(app)
	  @app = app
	end

  def call(env)
    
  	if env['PATH_INFO'] == '/api/events/track'
	    # Implement logic to handle Iterable API requests and return fake responses
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
	  else
	  	@app.call(env)
	  end
  end
end
