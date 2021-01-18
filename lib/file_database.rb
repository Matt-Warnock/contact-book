# frozen_string_literal: true

require 'json'

class FileDatabase
  def initialize(file_dir)
    @file = File.open(file_dir, 'r')
  end

  def all
    file.rewind
    JSON.parse(file.read, { symbolize_names: true })
  end

  private

  attr_reader :file
end
