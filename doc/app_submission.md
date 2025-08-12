




Submission:

○ Include all the source code, assets, and any additional documentation.
○ Provide instructions on how to set up and run the application.
○ Ensure the submission includes over-the-wire mocks for interactions with the
iterable.com API.
○ Discuss any trade-offs or decisions you made while implementing the solution.


Trade-offs or decisions

To mock the Iterable API for both development and testing purposes, you can create a simple Rack application that mimics the behavior of the Iterable API. This Rack application will act as a fake API server, and you can configure your Rails application to use it during development and testing. Additionally, we'll set up the configuration so that it seamlessly switches to a real Iterable API key in the production environment.



To mock the API for both development and testing purposes, we'll create a simple Rack application that simulates the behavior of the Iterable API.

You can create a Rack application to handle fake API requests. This application will be used to mock the Iterable API.

Additionally, the production environment is configured to use the real Iterable API key, ensuring seamless transition between environments.

we've set up a new Ruby on Rails project, created a fake Iterable API server, implemented the user interface with two buttons, integrated iterable.com functionality using a service class, and configured the production environment to use a real Iterable API key. This lays the foundation for further development to meet the requirements outlined in the problem statement.


 Let's focus solely on implementing the fake Iterable server and the API integration without considering the UI for now. We'll ensure that the Iterable API implementation covers all the use cases mentioned in the requirements.

 





Middleware (Fake API Server):

The middleware (Fake API Server) sits between the controllers and external APIs.

It intercepts requests from the controllers before they reach the actual external APIs and generates fake responses based on predefined rules or scenarios.

This allows developers to test their applications without relying on the real external APIs, ensuring consistent behavior and faster development cycles.

The Fake API Server should mimic the behavior of the real APIs closely, providing responses that simulate various scenarios (success, failure, invalid input, etc.).

In summary, the flow would be:

User interacts with the UI and triggers an action (e.g., submitting a form).
The UI sends an HTTP request to the appropriate controller endpoint.
The controller receives the request, processes it (validates input, interacts with models, etc.), and may interact with external services or the Fake API Server.
If necessary, the controller sends requests to the Fake API Server to simulate responses for certain scenarios.
The controller generates an appropriate HTTP response and sends it back to the UI.
The UI receives the response and updates its display accordingly, providing feedback to the user.




Valid - 200

curl -X POST -H "Content-Type: application/json" -d '{"eventName": "Event A", "email": "user@example.com", "userId": "123", "apiKey": "valid_api_key"}' http://localhost:3000/api/events/track  

{"msg":"Event A tracked successfully","code":"Success","params":{}}%   

curl -X POST -H "Content-Type: application/json" -d '{"eventName": "Event B", "email": "user@example.com", "userId": "123", "apiKey": "valid_api_key"}' http://localhost:3000/api/events/track

{"msg":"Event B tracked successfully - Email sent successfully","code":"Success","params":{}}%


Invalid Parameters - 400

curl -X POST -H "Content-Type: application/json" -d '{"eventName": "Event A", "userId": "123", "apiKey": "valid_api_key"}' http://localhost:3000/api/events/track

{"msg":"Invalid parameters","code":"InvalidParameters","params":{}}% 


curl -X POST -H "Content-Type: application/json" -d '{"eventName": "Event B", "userId": "123", "apiKey": "valid_api_key"}' http://localhost:3000/api/events/track

{"msg":"Invalid parameters - Failed to send email","code":"InvalidParameters","params":{}}%


Invalid Event Name C - 400

curl -X POST -H "Content-Type: application/json" -d '{"eventName": "Event C", "userId": "123", "apiKey": "valid_api_key"}' http://localhost:3000/api/events/track

{"msg":"Invalid parameters","code":"InvalidParameters","params":{}}% 


Invalid API Key - 401

curl -X POST -H "Content-Type: application/json" -d '{"eventName": "Event A", "email": "user@example.com", "userId": "123", "apiKey": "invalid_api_key"}' http://localhost:3000/api/events/track

{"msg":"Invalid API key","code":"BadApiKey","params":{}}% 

curl -X POST -H "Content-Type: application/json" -d '{"eventName": "Event B", "email": "user@example.com", "userId": "123", "apiKey": "invalid_api_key"}' http://localhost:3000/api/events/track

{"msg":"Invalid API key - Failed to send email","code":"BadApiKey","params":{}}%



App 


 curl -X POST -H "Content-Type: application/json" -d '{"eventName": "Event C", "userId": "123", "apiKey": "valid_api_key"}' http://localhost:3000/api/events/track

 curl -X POST -H "Content-Type: application/json" -d '{"eventName": "Event A", "email": "user@example.com", "userId": "123", "apiKey": "valid_api_key"}' http://localhost:3000/events/create_event

new

 curl -X POST -H "Content-Type: application/json" -d '{"eventName": "Event A", "email": "user@example.com", "userId": "123", "apiKey": "valid_api_key"}' http://localhost:3000/api/events/track







{"msg":"Invalid API key","code":"BadApiKey","params":{}}% 
{"msg":"Invalid parameters","code":"InvalidParameters","params":{}}% 
{"msg":"Invalid parameters - Failed to send email","code":"InvalidParameters","params":{}}%
{"msg":"Event B tracked successfully - Email sent successfully","code":"Success","params":{}}%

