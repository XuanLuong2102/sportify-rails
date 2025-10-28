require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

puts "== Cleaning up existing data =="
Role.delete_all
User.delete_all

puts "== Seeding roles =="
admin_role  = create(:role, :admin)
agency_role = create(:role, :agency)
user_role   = create(:role, :user)
puts "== End seeding roles =="

puts "== Seeding users =="
create(:user, :admin, role: admin_role)
create(:user, :agency, role: agency_role)
create(:user, :normal, role: user_role)
puts "== End seeding users =="
