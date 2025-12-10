require 'factory_bot_rails'
require 'csv'

include FactoryBot::Syntax::Methods

puts "== Cleaning up existing data =="
Role.delete_all
User.delete_all
Sportfield.delete_all
Place.delete_all
PlaceSport.delete_all
PlaceManager.delete_all

puts "========== Seeding roles =========="
roles_csv = Rails.root.join('db/seeds/roles.csv')
CSV.foreach(roles_csv, headers: true) do |row|
  Role.find_or_create_by!(name: row["name"])
end
puts "========== End seeding roles =========="

puts "========== Seeding users =========="
users_path = Rails.root.join('db/seeds/users.csv')

CSV.foreach(users_path, headers: true) do |row|
  role = Role.find_by(name: row["role_name"])
  User.create!(
    email: row["email"],
    username: row["username"],
    first_name: row["first_name"],
    middle_name: row["middle_name"],
    last_name: row["last_name"],
    phone: row["phone"],
    gender: row["gender"],
    is_locked: row["is_locked"] == "true",
    role_id: role&.role_id,
    password: row["password"]
  )
end
puts "========== End seeding users =========="

puts "========== Seeding sport field =========="
sportfields_path = Rails.root.join('db/seeds/sportfields.csv')
CSV.foreach(sportfields_path, headers: true) do |row|
  Sportfield.create!(
    name_en: row['name_en'],
    name_vi: row['name_vi'],
    description_en: row['description_en'],
    description_vi: row['description_vi']
  )
end
puts "========== End seeding sport field =========="

puts "========== Seeding places =========="
places_csv = Rails.root.join('db/seeds/places.csv')
CSV.foreach(places_csv, headers: true) do |row|
  Place.create!(
    name_en: row["name_en"],
    name_vi: row["name_vi"],
    address_en: row["address_en"],
    address_vi: row["address_vi"],
    city_en: row["city_en"],
    city_vi: row["city_vi"],
    district_en: row["district_en"],
    district_vi: row["district_vi"],
    description_en: row["description_en"],
    description_vi: row["description_vi"],
    is_close: row["is_close"] == "true",
    maintenance_place: row["maintenance_place"] == "true"
  )
end
puts "========== End seeding places ==========="

puts "========== Seeding place sports =========="
place_sports_csv = Rails.root.join('db/seeds/place_sports.csv')

CSV.foreach(place_sports_csv, headers: true) do |row|
  place = Place.find_by(name_en: row["place_name_en"])
  sport = Sportfield.find_by(name_en: row["sport_name_en"])

  PlaceSport.create!(
    place_id: place.place_id,
    sportfield_id: sport.sportfield_id,
    price_per_hour_usd: row["price_per_hour_usd"],
    price_per_hour_vnd: row["price_per_hour_vnd"],
    is_close: row["is_close"] == "true",
    maintenance_sport: row["maintenance_sport"] == "true"
  )
end
puts "========== End seeding place sports =========="

puts "========== Seeding place managers =========="
place_managers_csv = Rails.root.join('db/seeds/place_managers.csv')

CSV.foreach(place_managers_csv, headers: true) do |row|
  place = Place.find_by(name_en: row["place_name_en"])
  user = User.find_by(email: row["user_email"])

  PlaceManager.find_or_create_by!(
    place_id: place.place_id,
    user_id: user.user_id
  )
end
puts "========== End seeding place managers =========="
