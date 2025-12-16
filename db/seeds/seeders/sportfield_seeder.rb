module Seeds
  module Seeders
    class SportfieldSeeder < BaseSeeder
      def seed
        CSV.foreach(csv_path('sportfields'), headers: true) do |row|
          Sportfield.create!(
            name_en: row['name_en'],
            name_vi: row['name_vi'],
            description_en: row['description_en'],
            description_vi: row['description_vi']
          )
        end
      end
    end
  end
end
