json.array!(fields) do |field|
  json.partial! 'admin/fields/field', field: field
end
