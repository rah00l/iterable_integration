# spec/lib/fake_iterable_api_spec.rb

require 'rack/test'
require 'fake_iterable_api'
require 'json'  # Add this line to require the JSON module


describe FakeIterableApi do
  include Rack::Test::Methods

  def app
    # Instantiate an instance of FakeIterableApi and pass it to Rack::Lint
    FakeIterableApi.new(lambda { |env| [200, {}, [""]] })
  end

  # it 'returns a fake Iterable API response' do
  #   post '/api/events/track', {}, { 'CONTENT_TYPE' => 'application/json' }

  #   expect(last_response.status).to eq(200)
  #   expect(last_response.headers['Content-Type']).to eq('application/json')
  #   expect(JSON.parse(last_response.body)).to eq({ 'message' => 'Fake Iterable API response' })
  # end

  it 'returns a fake response' do
    post '/api/events/track', { eventName: 'Event A', userId: '123' }.to_json, { 'CONTENT_TYPE' => 'application/json' }

    expect(last_response.status).to eq(200)
    expect(last_response.headers['Content-Type']).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq({ "success" => true, "message" => 'Event tracked successfully' })
  end
end
