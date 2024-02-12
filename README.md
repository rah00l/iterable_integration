
# Iterable API Mock

This application serves as a mock for the Iterable API, allowing developers to simulate interactions with the Iterable platform without making actual requests to the Iterable servers. # My Project

This README provides an overview of the project, but you can find more detailed documentation in the [YARD documentation](doc/index.html).

## Installation

...


## Usage

### Setting Up the Application

1. Clone the repository to your local machine:

   ```
   git clone https://github.com/rah00l/iterable_integration.git
   ```

2. Install dependencies:

   ```
   bundle install
   ```

3. Set up the Rails application to use the fake Iterable API:

   Add the following configuration to `config/application.rb`:

   ```ruby
    # Add the middleware to the middleware stack
    config.middleware.use FakeIterableApi
   ```

4. Configure the routes for the fake Iterable API:

   Define routes in `config/routes.rb`:

   ```ruby
   Rails.application.routes.draw do
     # post '/events/track_event', to: 'events#track_event'
     root 'events#index'

     # Route for the create_event action in the EventsController
     post '/events/create_event', to: 'events#create_event'
   end
   ```

5. Run the Rails server:

   ```
   rails server
   ```

### Using the Iterable API Mock

The mock Iterable API provides endpoints to track events. You can use these endpoints to simulate event tracking behavior.

#### Tracking Events

- **Endpoint**: `POST /api/events/track`
- **Parameters**:
  - `eventName`: The name of the event to track (e.g., "Event A", "Event B").
  - `userId`: The ID of the user associated with the event.
  - `email`:  The email id of the user. 
  - `apiKey`: The api key to access endpoint.
- **Response**: Returns a JSON response indicating the success or failure of the event tracking operation.


Example request:

```bash
curl -X POST \
  http://localhost:3000/api/events/track \
  -H 'Content-Type: application/json' \
  -d '{
    "eventName": "Event A",
    "userId": "user123",
    "email": "user@example.com",
    "apiKey": "valid_api_key"
  }'
```

Example response:

```json
{
  "message": "Event A tracked successfully!"
}
```

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

---

Feel free to customize the README to include any additional information or instructions specific to your application.