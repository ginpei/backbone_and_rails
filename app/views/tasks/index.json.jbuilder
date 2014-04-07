json.array!(@tasks) do |task|
  json.extract! task, :id, :done, :title, :detail
  json.url task_url(task, format: :json)
end
