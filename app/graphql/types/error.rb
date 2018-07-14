class Types::Error < Types::BaseObject
  field :field, String, null: false
  field :message, String, null: false
end
