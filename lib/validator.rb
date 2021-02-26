# frozen_string_literal: true

class Validator
  def valid_choice?(option, max_choice)
    option.match?(/^[1-#{max_choice}]$/)
  end

  def valid_yes_no_answer?(value, valid_yes_no_reply)
    value.match?(/^[#{valid_yes_no_reply}]$/i)
  end

  def valid_string?(string)
    !string.empty?
  end

  def valid_field_value?(field, value)
    {
      phone: valid_phone?(value),
      email: valid_email?(value)
    }.fetch(field, true)
  end

  def valid_index?(value, max_index)
    value.match?(/^\d{1,2}$/) && value.to_i < max_index
  end

  def valid_field_name?(value, fields_to_display_names)
    fields_to_display_names.any? { |_, name| name.match?(/^#{value}\b/i) }
  end

  private

  def valid_phone?(value)
    value.match?(/^\d{11}$/)
  end

  def valid_email?(value)
    value.match?(/@/)
  end
end
