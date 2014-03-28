json.array!(@datasets) do |dataset|
  json.extract! dataset, 
  json.url dataset_url(dataset, format: :json)
end
