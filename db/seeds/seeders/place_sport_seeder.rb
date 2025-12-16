module Seeds
  module Seeders
    class PlaceSportSeeder < BaseSeeder
      def seed
        CSV.foreach(csv_path('place_sports'), headers: true) do |row|
          create_place_sport(row)
        end
      end

      private

      def create_place_sport(row)
        place = Place.find_by(name_en: row["place_name_en"])
        sport = Sportfield.find_by(name_en: row["sport_name_en"])

        PlaceSport.create!(
          place_id: place.place_id,
          sportfield_id: sport.sportfield_id,
          price_per_hour_usd: row["price_per_hour_usd"],
          price_per_hour_vnd: row["price_per_hour_vnd"],
          is_close: parse_boolean(row["is_close"]),
          maintenance_sport: parse_boolean(row["maintenance_sport"])
        )
      end
    end
  end
end
