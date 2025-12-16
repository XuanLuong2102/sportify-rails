module Seeds
  module Seeders
    class PlaceManagerSeeder < BaseSeeder
      def seed
        CSV.foreach(csv_path('place_managers'), headers: true) do |row|
          create_place_manager(row)
        end
      end

      private

      def create_place_manager(row)
        place = Place.find_by(name_en: row["place_name_en"])
        user = User.find_by(email: row["user_email"])

        PlaceManager.find_or_create_by!(
          place_id: place.place_id,
          user_id: user.user_id
        )
      end
    end
  end
end
