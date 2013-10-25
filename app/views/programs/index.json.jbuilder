json.array!(@programs) do |program|
  json.extract! program, :code, :name
  json.url program_url(program, format: :json)
end
