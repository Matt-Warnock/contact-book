# frozen_string_literal: true

require 'user_interface'

class Validator
  def valid_choice?(option)
    option.match?(/^[1-4]$/)
  end

  def valid_yes_no_answer?(value)
    value.match?(UserInterface::VALID_YES_NO_REPLY)
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
    value.to_i <= max_index
  end

  private

  def valid_phone?(value)
    value.match?(/^\d{11}$/)
  end

  def valid_email?(value)
    value.match?(/@/)
  end
end
