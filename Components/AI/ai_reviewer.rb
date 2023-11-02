require 'net/http'
require 'json'
require "google/cloud/vision/v1"

require_relative '../File/file_reader'
require_relative '../File/file_writer'
require_relative '../image_processor'

#ImageAnnotatorClient = Google::Cloud::Vision::V1::ImageAnnotatorClient
#IMAGE_FILE = 'resources/Images/Web_Page_Wikipedia.png'
# Step 2 - Convert the image to base64 format.
#base64_image = Base64.strict_encode64(File.new(IMAGE_FILE, 'rb').read)
#API_KEY = 'AIzaSyBJ9sgvpgOkIZRDKk-sXbglwhzl-wsLsFc' # Don't forget to protect your API key.


class AiReviewer
  def initialize(api_key, filepath, output_file)
    @filepath = filepath
    @api_key = api_key
    @api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{@api_key}"
    @output_file = output_file
  end

  def review_image_to_file
    # Step 3 - Set request JSON body.
    body = {
      requests: [{
                   image: {
                     content: ImageProcessor.new(@filepath).extract_data_from_image
                   },
                   features: [
                     {
                       type: 'LABEL_DETECTION', # Details are below.
                       maxResults: 100 # The number of results you would like to get
                     }
                   ]
                 }]
    }
    # Step 4 - Send request.
    uri = URI.parse(@api_url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request["Content-Type"] = "application/json"
    response = https.request(request, body.to_json)
    # Step 5 - Print the response in the console.
    #puts response.body
    FileWriter.new(@output_file,response.body, "AIReviewer").write_data_new
    #client = ::Google::Cloud::Vision::V1::ProductSearch::Client.new
    #request = ::Google::Cloud::Vision::V1::CreateProductSetRequest.new # (request fields as keyword arguments...)
    #response = client.create_product_set request
    #puts response
  end
  def review_image_to_json
    body = {
      requests: [{
                   image: {
                     content: ImageProcessor.new(@filepath).extract_data_from_image
                   },
                   features: [
                     {
                       type: 'LABEL_DETECTION', # Details are below.
                       maxResults: 100 # The number of results you would like to get
                     }
                   ]
                 }]
    }
    # Step 4 - Send request.
    uri = URI.parse(@api_url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request["Content-Type"] = "application/json"
    response = https.request(request, body.to_json)
    # Step 5 - Print the response in the console.
    response.body
    #client = ::Google::Cloud::Vision::V1::ProductSearch::Client.new
    #request = ::Google::Cloud::Vision::V1::CreateProductSetRequest.new # (request fields as keyword arguments...)
    #response = client.create_product_set request
    #puts response
  end
end
