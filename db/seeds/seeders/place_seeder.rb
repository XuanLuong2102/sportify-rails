module Seeds
  module Seeders
    class PlaceSeeder < BaseSeeder
      def seed
        CSV.foreach(csv_path('places'), headers: true) do |row|
          create_place(row)
        end
      end

      private

      def create_place(row)
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
          is_close: parse_boolean(row["is_close"]),
          maintenance_place: parse_boolean(row["maintenance_place"])
        )
      end
    end
  end
end
