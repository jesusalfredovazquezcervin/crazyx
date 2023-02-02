json.extract! event, :id, :name, :eventDate, :people, :status, :winner, :created_at, :updated_at
json.url event_url(event, format: :json)
