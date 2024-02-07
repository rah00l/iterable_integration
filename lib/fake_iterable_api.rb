class FakeIterableApi
  def self.call(env)
    # Implement logic to handle Iterable API requests and return fake responses
    status = 200
    headers = { 'Content-Type' => 'application/json' }
    body = '{"message": "Fake Iterable API response"}'  # Return body as a String

    [status, headers, [body]]  # Return as array with body as a string
  end
end
