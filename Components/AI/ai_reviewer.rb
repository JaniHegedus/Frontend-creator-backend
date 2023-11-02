require 'net/http'
require 'json'
require_relative '../File/file_reader'
require "google/cloud/vision"  # You'll need to include this gem

class AiReviewer
  def initialize(api_key, filepath, image_data)
    @filepath = filepath
    @image_data = FileReader.new(image_data).read_data
    @api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{api_key}"
  end

  def review_image
    puts @api_url
    body = {
      requests: [{
                   image: {
                     content: @image_data
                   },
                   features: [
                     {
                       type: 'LABEL_DETECTION', # Details are below.
                       maxResults: 10 # The number of results you would like to get
                     }
                   ]
                 }]
    }
    # Make a request
    uri = URI.parse(@api_url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request["Content-Type"] = "application/json"
    response = https.request(request, body.to_json)
    puts response.body
  end
end
