module Seeds
  module Seeders
    class BaseSeeder
      include SeedHelper

      def self.seed
        new.seed
      end

      def seed
        raise NotImplementedError
      end
    end
  end
end
