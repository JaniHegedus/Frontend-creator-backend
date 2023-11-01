require 'net/http'
require 'json'
require_relative '../Components/file_reader'
require "google/cloud/vision"  # You'll need to include this gem

class AiReviewer

  ENV['GOOGLE_APPLICATION_CREDENTIALS'] = "./gothic-welder-403820-f039c127ce73.json"

  def initialize(google_cloud_vision_key, filepath)
    @vision_key = google_cloud_vision_key
    @filepath = filepath
    @image_data = FileReader.new(filepath).read_data
    @review_data = nil
  end

  def review_image
    # Initialize the Vision client
    vision = Google::Cloud::Vision.image_annotator

    # Make a request
    response = vision.annotate_image(
      image: @image_data,
      features: [{ type: :LABEL_DETECTION, max_results: 5 }]
    )

    @review_data = response.responses.first.label_annotations.map(&:description)
  end
end
