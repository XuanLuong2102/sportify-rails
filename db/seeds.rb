require_relative 'seeds/seed_helper'
require_relative 'seeds/constants'
require_relative 'seeds/seeders/base_seeder'
require_relative 'seeds/cleaners/database_cleaner'
require_relative 'seeds/seeders/role_seeder'
require_relative 'seeds/seeders/user_seeder'
require_relative 'seeds/seeders/sportfield_seeder'
require_relative 'seeds/seeders/place_seeder'
require_relative 'seeds/seeders/place_sport_seeder'
require_relative 'seeds/seeders/place_manager_seeder'
require_relative 'seeds/seeders/product_variant_generator'
require_relative 'seeds/seeders/product_stock_generator'
require_relative 'seeds/seeders/product_seeder'

module Seeds
  class Runner
    include SeedHelper

    def run
      cleanup_database
      seed_all_data
    end

    private

    def cleanup_database
      log_section("Cleaning up existing data") do
        Cleaners::DatabaseCleaner.clean_all
      end
    end

    def seed_all_data
      seed_roles
      seed_users
      seed_sportfields
      seed_places
      seed_place_sports
      seed_place_managers
      seed_products
    end

    def seed_roles
      log_section("Seeding roles") do
        Seeders::RoleSeeder.seed
      end
    end

    def seed_users
      log_section("Seeding users") do
        Seeders::UserSeeder.seed
      end
    end

    def seed_sportfields
      log_section("Seeding sport fields") do
        Seeders::SportfieldSeeder.seed
      end
    end

    def seed_places
      log_section("Seeding places") do
        Seeders::PlaceSeeder.seed
      end
    end

    def seed_place_sports
      log_section("Seeding place sports") do
        Seeders::PlaceSportSeeder.seed
      end
    end

    def seed_place_managers
      log_section("Seeding place managers") do
        Seeders::PlaceManagerSeeder.seed
      end
    end

    def seed_products
      log_section("Seeding products") do
        Seeders::ProductSeeder.seed_all
      end
    end
  end
end

Seeds::Runner.new.run
