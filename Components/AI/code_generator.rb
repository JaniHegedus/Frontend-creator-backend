require 'json'
require 'net/http'
require_relative '../File/file_writer'

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
    FileWriter.new("OUT/Results/output.html", code['html'], "AiGenerator").write_data_new
    FileWriter.new("OUT/Results/styles.css", code['css'], "AiGenerator").write_data_new
  end
end