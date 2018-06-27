class Types::PinCode < Types::BaseScalar
  graphql_name 'PinCode'

  def self.coerce_input(input_value, context)
    input_value.present? ? input_value.to_i : ""
  end

  def self.coerce_result(ruby_value, context)
    ruby_value.to_s
  end
end
