require 'sinatra'
require 'json'
require 'rack/cors'

require_relative '../../Components/AI/ai_reviewer'
require_relative '../../Components/config'

config = Config.new(type: "google")
filename_without_extension = File.basename("resources/Images/Web_Page_Wikipedia.png", ".*")
output_path = File.expand_path("test/OUT/#{filename_without_extension}.json")

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
get '/test/aiImageTest' do
  reviewer = AiReviewer.new(config.load,"resources/Images/Web_Page_Wikipedia.png", output_path)
  reviewer.review_image_to_file
  content_type :json
  reviewer.review_image_to_json
end


# You can define more routes and handlers for your application
