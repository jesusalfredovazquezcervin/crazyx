json.extract! player, :id, :name, :category, :leftHanded, :birthDate, :eventScore, :totalScore, :created_at, :updated_at
json.url player_url(player, format: :json)
