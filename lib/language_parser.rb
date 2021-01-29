# frozen_string_literal: true

require 'pathname'

class LanguageParser
  def initialize(file_path)
    @file = Pathname.new(file_path)
  end

  def language
    validate_file
  end

  private

  attr_reader :file

  def validate_file
    raise 'Invalid .yml file' unless file.to_s.match?(/[a-z]{2}.yml$/)
  end
end
