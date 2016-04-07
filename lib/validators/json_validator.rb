class JsonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, 'must be valid JSON' unless valid_json?(value)
  end

  def valid_json?(json)
    JSON.parse(json)
    true
  rescue
    false
  end
end
