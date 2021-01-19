# frozen_string_literal: true

require 'json'

class FileDatabase
  def initialize(file_dir)
    @file = File.open(file_dir, 'r')
  end

  def all
    file.rewind
    convert_from_json(file.read)
  end

  private

  def convert_from_json(data)
    JSON.parse(data, { symbolize_names: true })
  end

  attr_reader :file
end
