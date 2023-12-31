require 'net/http'
require 'uri'
require 'json'

class CodeGenerator
  attr_reader :code  # Reader for @code

  def initialize(api_key, review_data="")
    @api_key = api_key
    @review_data = review_data
    @code = {'html' => '', 'css' => ''}
    make_request
  end

  def make_request
    begin
    uri = URI('https://api.openai.com/v1/chat/completions')
    header = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{@api_key}"
    }

    prompt = "Generate an HTML and CSS based on the following review data: #{@review_data}"

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri, header)

    request.body = {
      model: "gpt-4",
      messages: [
        { role: "system", content: "You are a code generator that creates HTML and CSS." },
        { role: "user", content: prompt }
      ]
    }.to_json

    @response = http.request(request)

    if @response.is_a?(Net::HTTPSuccess)
      generated_content = JSON.parse(@response.body)['choices'].first['message']['content']
      parse_generated_content(generated_content)
    else
      raise "HTTP Error: #{@response.code} #{@response.message}"
    end
    rescue Net::HTTPTooManyRequests => e
      retries += 1
      if retries <= 3 # You can adjust the maximum number of retries
        sleep(2**retries) # Exponential backoff
        retry
      else
        raise "HTTP Error: #{e.message}"
      end
    rescue JSON::ParserError => e
      raise "JSON Parsing Error: #{e.message}"
    rescue Net::HTTPFatalError => e
      raise "HTTP Fatal Error: #{e.message}"
    end
  end

  def parse_generated_content(content)
    html_match = content.match(/```html\n(.+?)```/m)
    css_match = content.match(/```css\n(.+?)```/m)
    @code['html'] = html_match ? html_match[1].strip : ''
    @code['css'] = css_match ? css_match[1].strip : ''
  end
  def save_generated_code(test = false, filename)
    filename_without_extension = File.basename(filename, ".*")
    dir_prefix = test ? "test/OUT" : "OUT"
    FileUtils.mkdir_p("#{dir_prefix}/#{filename_without_extension}/Results")

    html_path = "#{dir_prefix}/#{filename_without_extension}/Results/output.html"
    css_path = "#{dir_prefix}/#{filename_without_extension}/Results/styles.css"

    FileWriter.new(html_path, @code['html'], "AiGenerator").write_data_new
    FileWriter.new(css_path, @code['css'], "AiGenerator").write_data_new

    #puts "@code is: #{@code.inspect}"
  end
  def get_response
    @response.body
  end
end
