# frozen_string_literal: true
require 'fileutils'
class FileWriter
  def initialize(file_path, data, processname)
    @file_path = file_path
    @data = data
    @processname = processname
  end

  def write_data_new
    # Ensure directory exists
    FileUtils.mkdir_p(File.dirname(@file_path))

    File.open(@file_path, 'w') do |file|
      file.write(@data)
    end

    raise "File creation failed!" unless File.exist?(@file_path)
  end
  def write_data_append
    File.open(@file_path, 'a') do |file|
      file.write(@data)
    end

    File.read(@file_path)
    raise "File creation failed!" unless File.exist?(@file_path)
    puts @processname + @file_path
  end
end
