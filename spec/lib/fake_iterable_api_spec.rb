# spec/lib/fake_iterable_api_spec.rb

require 'rack/test'
require 'fake_iterable_api'
require 'json'

describe FakeIterableApi do
  include Rack::Test::Methods

  def app
    FakeIterableApi.new(lambda { |env| [200, {}, [""]] })
  end

  it 'returns a fake response for Event A - Valid 200' do
    env = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/events/track', { eventName: 'Event A', userId: '123', "email": "user@example.com", apiKey: 'valid_api_key' }.to_json, env

    expect(last_response.status).to eq(200)
    expect(last_response.headers['Content-Type']).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq({
      "msg" => "Event A tracked successfully",
      "code" => "Success",
      "params" => {}
    })
  end

  it 'returns a fake response for Event B - Valid 200' do
    env = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/events/track', { eventName: 'Event B', userId: '123', "email": "user@example.com", apiKey: 'valid_api_key' }.to_json, env

    expect(last_response.status).to eq(200)
    expect(last_response.headers['Content-Type']).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq({
      "msg" => "Success",
      "code" => 200,
      "params" => { "successCount" => 1, "failureCount" => 0 }
    })

    # Add a Set-Cookie header to the response
    header 'Set-Cookie', 'cookie_name=cookie_value'
  end

end
