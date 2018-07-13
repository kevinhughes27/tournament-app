class Types::NullableInt < Types::BaseScalar
  graphql_name 'NullableInt'

  def self.coerce_input(input_value, context)
    input_value.present? ? input_value.to_i : ""
  end

  def self.coerce_result(ruby_value, context)
    ruby_value.present? ? ruby_value.to_i : nil
  end
end
