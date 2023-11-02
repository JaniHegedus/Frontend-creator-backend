require 'sinatra'
require 'json'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :options]
  end
end
# Explicitly set the server to Webrick
set :server, 'webrick'

# Define a route that responds with a JSON message
get '/hello' do
  content_type :json
  { message: 'Hello, Ruby Backend!' }.to_json
end


# You can define more routes and handlers for your application
