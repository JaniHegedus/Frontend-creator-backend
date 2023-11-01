require 'json'
require 'net/http'

class CodeGenerator
  def initialize(api_key)
    @api_key = api_key
  end

  def send_review_for_code_generation(review_data)
    # Your OpenAI endpoint and details might differ, please adjust accordingly
    uri = URI('https://api.openai.com/v1/models/gpt-4')
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{@api_key}"
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, headers)
    request.body = { review_data: review_data }.to_json

    response = http.request(request)
    JSON.parse(response.body)
  end

  def save_generated_code(code)
    File.open('output.html', 'w') do |file|
      file.write(code['html']) # Adjust based on the structure of `code`
    end

    File.open('styles.css', 'w') do |file|
      file.write(code['css']) # Adjust based on the structure of `code`
    end
  end
end