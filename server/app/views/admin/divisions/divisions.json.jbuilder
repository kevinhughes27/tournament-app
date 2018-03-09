json.array!(@divisions) do |division|
  json.partial! 'admin/divisions/division', division: division
end
