# frozen_string_literal: true

class FileReader
  def initialize(file_path)
    @file_path = file_path
  end

  def read_data
    raise "File #{@file_path} does not exist!" unless File.exist?(@file_path)

    File.read(@file_path)
  end
end
