# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Event.create(name: "Seis loco top padel", eventDate: Date.today, people: 12, status: "Open")
Event.create(name: "Seis loco Padel Nuestro", eventDate: Date.today - 10, people: 16, status: "Open")
Event.create(name: "Seis loco Femac", eventDate: Date.today-3, people: 12, status: "Open")
Event.create(name: "Seis loco Femac", eventDate: Date.today-10, people: 12, status: "Open")
Event.create(name: "Seis loco Top padel Alfredo y amigos", eventDate: Date.today-1, people: 8, status: "Open")


Player.create(name: "Eduardo Garcia Ruiz", category: 4, birthDate: DateTime.new(1993, 1, 6), leftHanded: false)
Player.create(name: "Alfredo Vazquez Cervin", category: 4, birthDate: DateTime.new(1977, 12, 8), leftHanded: false)
Player.create(name: "Juan Pablo Ledesma", category: 4, birthDate: DateTime.new(1990, 3, 12), leftHanded: false)
Player.create(name: "Rodrigo Palazuelos Lopez", category: 4, birthDate: DateTime.new(1991, 11, 23), leftHanded: false)
Player.create(name: "Maximiliano Rodriguez", category: 4, birthDate: DateTime.new(1989, 11, 23), leftHanded: false)
Player.create(name: "Jorge Martinez", category: 4, birthDate: DateTime.new(1995, 11, 23), leftHanded: false)
Player.create(name: "Raul Gutierrez", category: 4, birthDate: DateTime.new(1975, 1, 21), leftHanded: true)

MatchPlayer.create(event_id:1,player_id:1,status: 'OnBoard')
MatchPlayer.create(event_id:1,player_id:2,status: 'OnBoard')
MatchPlayer.create(event_id:1,player_id:3,status: 'OnBoard')
MatchPlayer.create(event_id:1,player_id:4,status: 'OnBoard')
MatchPlayer.create(event_id:1,player_id:5,status: 'OnBoard')
MatchPlayer.create(event_id:1,player_id:6,status: 'OnBoard')
MatchPlayer.create(event_id:1,player_id:7,status: 'OnBoard')


