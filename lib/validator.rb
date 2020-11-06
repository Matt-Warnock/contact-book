# frozen_string_literal: true

require 'constants'

class Validator
  def valid_choice?(option)
    option.match?(/^[1-4]$/)
  end

  def valid_yes_no_answer?(value)
    value.match?(Constants::VALID_YES_NO_REPLY)
  end

  def valid_string?(string)
    string.match?(/\w/)
  end

  def valid_field?(field, value)
    {
      phone: valid_phone?(value),
      email: valid_email?(value)
    }.fetch(field, true)
  end

  def valid_index?(value, max_index)
    value.to_i < max_index
  end

  def valid_field_name?(value)
    Constants::FIELDS_TO_DISPLAY_NAMES.any? { |_, name| name.match(/#{value}/i) }
  end

  private

  def valid_phone?(value)
    value.match?(/^\d{11}$/)
  end

  def valid_email?(value)
    value.match?(/@/)
  end
end
