# frozen_string_literal: true

class Validator
  def valid_choice?(option)
    option.match?(/^[1-2]$/)
  end

  def valid_field?(field, value)
    {
      phone: vaild_phone?(value),
      email: valid_email?(value)
    }.fetch(field, true)
  end

  def vaild_phone?(value)
    value.match?(/^\d{11}$/)
  end

  def valid_email?(value)
    value.match?(/@/)
  end
end
