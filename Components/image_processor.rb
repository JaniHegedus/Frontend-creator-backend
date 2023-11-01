require 'base64'

class ImageProcessor
  def initialize(image_path)
    @image_path = image_path
  end

  def extract_data_from_image
    # Convert the image to a base64 encoded string
    Base64.strict_encode64(File.open(@image_path, 'rb').read)
  end

  def save_extracted_data(data)
    filename_without_extension = File.basename(@image_path, ".*")
    absolute_path = File.expand_path("test/#{filename_without_extension}.txt")
    File.open(absolute_path, 'w') do |file|
      file.write(data)
    end
    raise "File creation failed!" unless File.exist?(absolute_path)
    print absolute_path
  end
end
