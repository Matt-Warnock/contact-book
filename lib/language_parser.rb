# frozen_string_literal: true

require 'yaml'

class LanguageParser
  def initialize(file_path_object)
    @file = file_path_object
  end

  def messages
    JSON.parse(YAML.load_file(file).to_json, object_class: OpenStruct)
  rescue Errno::ENOENT
    raise 'Invalid or missing .yml file'
  end

  private

  attr_reader :file
end
