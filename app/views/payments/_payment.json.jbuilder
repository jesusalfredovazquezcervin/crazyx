json.extract! payment, :id, :event_id, :player_id, :cost, :retainer, :payment_type, :reference, :comments, :created_at, :updated_at
json.url payment_url(payment, format: :json)
