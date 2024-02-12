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
      "msg" => "Event B tracked successfully - Email sent successfully",
      "code" => "Success",
      "params" => {}
    })
  end

  it 'returns a fake response for Event A - Invalid Parameters 400' do
    env = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/events/track', { eventName: 'Event A', userId: '123', apiKey: 'valid_api_key' }.to_json, env

    expect(last_response.status).to eq(400)
    expect(last_response.headers['Content-Type']).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq({
      "msg" => "Invalid parameters",
      "code" => "InvalidParameters",
      "params" => {}
    })
  end

  it 'returns a fake response for Event B - Invalid Parameters 400' do
    env = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/events/track', { eventName: 'Event B', userId: '123', apiKey: 'valid_api_key' }.to_json, env

    expect(last_response.status).to eq(400)
    expect(last_response.headers['Content-Type']).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq({
      "msg" => "Invalid parameters - Failed to send email",
      "code" => "InvalidParameters",
      "params" => {}
    })
  end

  it 'returns a fake response for Invalid Event Name C 400' do
    env = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/events/track', { eventName: 'Event C', userId: '123', "email": "user@example.com", apiKey: 'valid_api_key' }.to_json, env

    expect(last_response.status).to eq(400)
    expect(last_response.headers['Content-Type']).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq({
      "msg" => "Invalid event name",
      "code" => "InvalidEventName",
      "params" => {}
    })
  end

  it 'returns a fake response for Invalid API Key 401' do
    env = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/events/track', { eventName: 'Event A', userId: '123', apiKey: 'invalid_api_key' }.to_json, env

    expect(last_response.status).to eq(401)
    expect(last_response.headers['Content-Type']).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq({
      "msg" => "Invalid API key",
      "code" => "BadApiKey",
      "params" => {}
    })
  end

  it 'returns a fake response for Invalid API Key for Event B 401' do
    env = { 'CONTENT_TYPE' => 'application/json' }
    post '/api/events/track', { eventName: 'Event B', userId: '123', apiKey: 'invalid_api_key' }.to_json, env

    expect(last_response.status).to eq(401)
    expect(last_response.headers['Content-Type']).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq({
      "msg" => "Invalid API key - Failed to send email",
      "code" => "BadApiKey",
      "params" => {}
    })
  end
end
