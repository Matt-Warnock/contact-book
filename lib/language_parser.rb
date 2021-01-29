# frozen_string_literal: true

require 'pathname'
require 'yaml'

class LanguageParser
  def initialize(file_path)
    @file = Pathname.new(file_path)
  end

  def language
    validate_file
    JSON.parse(YAML.load_file(file).to_json, object_class: OpenStruct)
  end

  private

  attr_reader :file

  def validate_file
    raise 'Invalid .yml file' unless file.to_s.match?(/[a-z]{2}.yml$/)
  end
end
