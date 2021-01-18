# frozen_string_literal: true

require 'json'

class FileDatabase
  def initialize(file)
    @file = file
  end

  def all
    file.open.rewind
    JSON.parse(file.read, { symbolize_names: true })
  end

  private

  attr_reader :file
end
