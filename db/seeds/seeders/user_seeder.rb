module Seeds
  module Seeders
    class UserSeeder < BaseSeeder
      def seed
        CSV.foreach(csv_path('users'), headers: true) do |row|
          create_user(row)
        end
      end

      private

      def create_user(row)
        role = Role.find_by(name: row["role_name"])
        
        User.create!(
          email: row["email"],
          username: row["username"],
          first_name: row["first_name"],
          middle_name: row["middle_name"],
          last_name: row["last_name"],
          phone: row["phone"],
          gender: row["gender"],
          is_locked: parse_boolean(row["is_locked"]),
          role_id: role&.role_id,
          password: row["password"]
        )
      end
    end
  end
end
