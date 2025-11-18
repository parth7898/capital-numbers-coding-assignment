class EmailValidator < ActiveModel::EachValidator
  VALID_EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/i

  def validate_each(record, attribute, value)
    unless value.present? && value.match?(VALID_EMAIL_REGEX)
      record.errors.add(attribute, (options[:message] || "is not a valid email"))
    end
  end
end
