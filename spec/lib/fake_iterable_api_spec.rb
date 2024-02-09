# spec/lib/fake_iterable_api_spec.rb

require 'rack/test'
require 'fake_iterable_api'
require 'json'

describe FakeIterableApi do
  include Rack::Test::Methods

  def app
    # Instantiate an instance of FakeIterableApi and pass it to Rack::Lint
    FakeIterableApi.new(lambda { |env| [200, {}, [""]] })
  end

  it 'returns a fake response for Event A' do
    env = { 'CONTENT_TYPE' => 'application/json', 'rack.session' => { 'HTTP_COOKIE' => 'cookie_name=cookie_value' } }
    post '/api/events/track', { eventName: 'Event A', userId: '123' }.to_json, env


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
