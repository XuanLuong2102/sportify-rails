module Seeds
  module Seeders
    class RoleSeeder < BaseSeeder
      def seed
        CSV.foreach(csv_path('roles'), headers: true) do |row|
          Role.find_or_create_by!(name: row["name"])
        end
      end
    end
  end
end
