class Types::Map < Types::BaseObject
  graphql_name "Map"
  description "Tourgraphql_nament Map"
  field :lat, Float, null: false
  field :long, Float, null: false
  field :zoom, Int, null: false
end
