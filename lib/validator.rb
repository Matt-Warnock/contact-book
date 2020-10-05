# frozen_string_literal: true

class Validator
  VALID_YES_NO_REPLY = /^[yn]$/i.freeze

  def valid_choice?(option)
    option.match?(/^[1-2]$/)
  end

  def valid_field?(field, value)
    {
      phone: valid_phone?(value),
      email: valid_email?(value)
    }.fetch(field, true)
  end

  def valid_phone?(value)
    value.match?(/^\d{11}$/)
  end

  def valid_email?(value)
    value.match?(/@/)
  end

  def valid_yes_no_answer?(value)
    value.match?(VALID_YES_NO_REPLY)
  end
end
