require 'minitest/autorun'

require_relative '../Components/image_processor'
require_relative '../Ai/ai_reviewer'
require_relative '../Ai/code_generator'
require_relative '../Components/config'
class AiTest < Minitest::Test
  def setup
    config = Config.new(type: "openai")
    @filepath = "test/Web_Page_Wikipedia.png"
    refute_nil @filepath, "Image path is not set!"

    # Create the file first before initializing AiReviewer
    @image_processor = ImageProcessor.new(@filepath)
    data = @image_processor.extract_data_from_image
    @image_processor.save_extracted_data(data)

    # Now initialize AiReviewer
    unless @image_path
      puts "Image path is not set!"
      return
    end
    filename_without_extension = File.basename(@image_path, ".*")
    absolute_path = File.expand_path("test/#{filename_without_extension}.txt")
    @reviewer = AiReviewer.new(config.load, absolute_path) # Adjusted the path to make sure it looks in the test folder
    @generator = CodeGenerator.new(config.load)
  end


  def teardown
    # If you have any cleanup steps after tests, add them here.
  end


  def test_ai_review
    config = Config.new(type: "google")
    reviewer = AiReviewer.new(config.load,@filepath) # or some initialization logic
    reviewer.review_image
    # ... your test logic here
  end

  def test_code_generation
    config = Config.new(type: "openai")
    generator = CodeGenerator.new(config.load) # or some initialization logic
    generator.send_review_for_code_generation(@filepath)
    # ... your test logic here
  end

end
