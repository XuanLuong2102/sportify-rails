# Agency Management System - Seed Data
# This file contains sample data for testing the Agency management system

# Create roles if they don't exist
puts "Creating roles..."
admin_role = Role.find_or_create_by(name: 'admin')
agency_role = Role.find_or_create_by(name: 'agency')
user_role = Role.find_or_create_by(name: 'user')

# Create admin user
puts "Creating admin user..."
admin = User.find_or_create_by(email: 'admin@sportify.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'Admin'
  user.last_name = 'User'
  user.role = admin_role
  user.is_locked = false
end
puts "✓ Admin user: admin@sportify.com / password123"

# Create agency users
puts "\nCreating agency users..."

agency1 = User.find_or_create_by(email: 'agency1@sportify.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'John'
  user.last_name = 'Agency'
  user.role = agency_role
  user.is_locked = false
end
puts "✓ Agency 1: agency1@sportify.com / password123"

agency2 = User.find_or_create_by(email: 'agency2@sportify.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'Jane'
  user.last_name = 'Agency'
  user.role = agency_role
  user.is_locked = false
end
puts "✓ Agency 2: agency2@sportify.com / password123"

# Create regular users
puts "\nCreating regular users..."

customer1 = User.find_or_create_by(email: 'customer1@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'Alice'
  user.last_name = 'Customer'
  user.role = user_role
  user.is_locked = false
end
puts "✓ Customer 1: customer1@example.com / password123"

customer2 = User.find_or_create_by(email: 'customer2@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'Bob'
  user.last_name = 'Customer'
  user.role = user_role
  user.is_locked = false
end
puts "✓ Customer 2: customer2@example.com / password123"

# Create places
puts "\nCreating places..."

place1 = Place.find_or_create_by(
  name_en: 'Downtown Sports Center',
  name_vi: 'Trung tâm thể thao trung tâm'
) do |place|
  place.address_en = '123 Main Street'
  place.address_vi = '123 Đường Chính'
  place.city_en = 'Ho Chi Minh City'
  place.city_vi = 'Thành phố Hồ Chí Minh'
  place.district_en = 'District 1'
  place.district_vi = 'Quận 1'
  place.description_en = 'Modern sports facility in the heart of the city'
  place.description_vi = 'Cơ sở thể thao hiện đại ở trung tâm thành phố'
  place.open_time = '06:00:00'
  place.close_time = '22:00:00'
  place.is_close = false
  place.maintenance_place = false
end
puts "✓ Place 1: #{place1.name_en}"

place2 = Place.find_or_create_by(
  name_en: 'Eastside Fitness Hub',
  name_vi: 'Trung tâm thể dục miền Đông'
) do |place|
  place.address_en = '456 East Avenue'
  place.address_vi = '456 Đại lộ Đông'
  place.city_en = 'Ho Chi Minh City'
  place.city_vi = 'Thành phố Hồ Chí Minh'
  place.district_en = 'District 2'
  place.district_vi = 'Quận 2'
  place.description_en = 'Family-friendly sports center'
  place.description_vi = 'Trung tâm thể thao thân thiện với gia đình'
  place.open_time = '07:00:00'
  place.close_time = '21:00:00'
  place.is_close = false
  place.maintenance_place = false
end
puts "✓ Place 2: #{place2.name_en}"

place3 = Place.find_or_create_by(
  name_en: 'Westside Arena',
  name_vi: 'Sân vận động miền Tây'
) do |place|
  place.address_en = '789 West Road'
  place.address_vi = '789 Đường Tây'
  place.city_en = 'Ho Chi Minh City'
  place.city_vi = 'Thành phố Hồ Chí Minh'
  place.district_en = 'District 5'
  place.district_vi = 'Quận 5'
  place.description_en = 'Professional sports arena'
  place.description_vi = 'Sân vận động thể thao chuyên nghiệp'
  place.open_time = '06:00:00'
  place.close_time = '23:00:00'
  place.is_close = false
  place.maintenance_place = false
end
puts "✓ Place 3: #{place3.name_en}"

# Assign places to agencies
puts "\nAssigning places to agencies..."

PlaceManager.find_or_create_by(user: agency1, place: place1)
PlaceManager.find_or_create_by(user: agency1, place: place2)
puts "✓ Agency 1 manages: #{place1.name_en}, #{place2.name_en}"

PlaceManager.find_or_create_by(user: agency2, place: place3)
puts "✓ Agency 2 manages: #{place3.name_en}"

# Create sport fields if Sportfield model exists
if defined?(Sportfield)
  puts "\nCreating sport fields..."
  
  football = Sportfield.find_or_create_by(
    name_en: 'Football',
    name_vi: 'Bóng đá'
  ) do |sf|
    sf.description_en = '11-a-side football field'
    sf.description_vi = 'Sân bóng đá 11 người'
  end
  puts "✓ Sport field: #{football.name_en}"
  
  basketball = Sportfield.find_or_create_by(
    name_en: 'Basketball',
    name_vi: 'Bóng rổ'
  ) do |sf|
    sf.description_en = 'Full-size basketball court'
    sf.description_vi = 'Sân bóng rổ đầy đủ kích thước'
  end
  puts "✓ Sport field: #{basketball.name_en}"
  
  tennis = Sportfield.find_or_create_by(
    name_en: 'Tennis',
    name_vi: 'Quần vợt'
  ) do |sf|
    sf.description_en = 'Professional tennis court'
    sf.description_vi = 'Sân tennis chuyên nghiệp'
  end
  puts "✓ Sport field: #{tennis.name_en}"
  
  # Create place sports
  puts "\nCreating place sports..."
  
  PlaceSport.find_or_create_by(place: place1, sportfield: football) do |ps|
    ps.price_per_hour_vnd = 200000
    ps.price_per_hour_usd = 8.5
    ps.is_active = true
  end
  
  PlaceSport.find_or_create_by(place: place1, sportfield: basketball) do |ps|
    ps.price_per_hour_vnd = 150000
    ps.price_per_hour_usd = 6.5
    ps.is_active = true
  end
  
  PlaceSport.find_or_create_by(place: place2, sportfield: football) do |ps|
    ps.price_per_hour_vnd = 180000
    ps.price_per_hour_usd = 7.5
    ps.is_active = true
  end
  
  PlaceSport.find_or_create_by(place: place2, sportfield: tennis) do |ps|
    ps.price_per_hour_vnd = 120000
    ps.price_per_hour_usd = 5.0
    ps.is_active = true
  end
  
  PlaceSport.find_or_create_by(place: place3, sportfield: football) do |ps|
    ps.price_per_hour_vnd = 250000
    ps.price_per_hour_usd = 10.5
    ps.is_active = true
  end
  
  PlaceSport.find_or_create_by(place: place3, sportfield: basketball) do |ps|
    ps.price_per_hour_vnd = 180000
    ps.price_per_hour_usd = 7.5
    ps.is_active = true
  end
  
  puts "✓ Created place sports for all places"
end

# Create sample orders
if defined?(Order)
  puts "\nCreating sample orders..."
  
  3.times do |i|
    order = Order.find_or_create_by(order_code: "ORD-PLACE1-#{i + 1}") do |o|
      o.user = customer1
      o.place = place1
      o.status = ['pending', 'confirmed', 'shipping'].sample
      o.total_amount_vnd = [100000, 200000, 300000].sample
      o.total_amount_usd = [4.5, 8.5, 12.5].sample
      o.created_at = rand(30).days.ago
    end
  end
  
  2.times do |i|
    order = Order.find_or_create_by(order_code: "ORD-PLACE2-#{i + 1}") do |o|
      o.user = customer2
      o.place = place2
      o.status = ['pending', 'confirmed', 'completed'].sample
      o.total_amount_vnd = [150000, 250000].sample
      o.total_amount_usd = [6.5, 10.5].sample
      o.created_at = rand(30).days.ago
    end
  end
  
  puts "✓ Created sample orders"
end

# Create sample bookings
if defined?(Booking) && defined?(PlaceSport)
  puts "\nCreating sample bookings..."
  
  place_sports = PlaceSport.where(place: [place1, place2, place3])
  
  5.times do |i|
    place_sport = place_sports.sample
    Booking.find_or_create_by(
      user: [customer1, customer2].sample,
      place_sport: place_sport,
      booking_date: rand(30).days.from_now.to_date,
      start_time: ['08:00', '10:00', '14:00', '16:00', '18:00'].sample
    ) do |b|
      b.end_time = '10:00'
      b.total_price = rand(100000..300000)
      b.status = ['pending', 'approved', 'completed'].sample
      b.payment_status = ['unpaid', 'paid'].sample
    end
  end
  
  puts "✓ Created sample bookings"
end

# Create sample products if Product model exists
if defined?(Product)
  puts "\nCreating sample products..."
  
  # Create product categories and brands if they exist
  if defined?(ProductCategory)
    apparel = ProductCategory.find_or_create_by(name_en: 'Apparel', name_vi: 'Quần áo')
    equipment = ProductCategory.find_or_create_by(name_en: 'Equipment', name_vi: 'Thiết bị')
  end
  
  if defined?(ProductBrand)
    nike = ProductBrand.find_or_create_by(name: 'Nike')
    adidas = ProductBrand.find_or_create_by(name: 'Adidas')
  end
  
  product1 = Product.find_or_create_by(
    name_en: 'Football Jersey',
    name_vi: 'Áo bóng đá'
  ) do |p|
    p.description_en = 'Professional football jersey'
    p.description_vi = 'Áo bóng đá chuyên nghiệp'
    p.price_vnd = 500000
    p.price_usd = 21
    p.product_category = apparel if defined?(apparel)
    p.product_brand = nike if defined?(nike)
  end
  
  product2 = Product.find_or_create_by(
    name_en: 'Basketball',
    name_vi: 'Bóng rổ'
  ) do |p|
    p.description_en = 'Official size basketball'
    p.description_vi = 'Bóng rổ kích thước chính thức'
    p.price_vnd = 300000
    p.price_usd = 12.5
    p.product_category = equipment if defined?(equipment)
    p.product_brand = adidas if defined?(adidas)
  end
  
  puts "✓ Created sample products"
  
  # Create product listings
  if defined?(ProductListing)
    puts "\nCreating product listings..."
    
    ProductListing.find_or_create_by(product: product1, place: place1) do |pl|
      pl.is_active = true
      pl.stock_quantity = 50
    end
    
    ProductListing.find_or_create_by(product: product2, place: place1) do |pl|
      pl.is_active = true
      pl.stock_quantity = 30
    end
    
    ProductListing.find_or_create_by(product: product1, place: place2) do |pl|
      pl.is_active = true
      pl.stock_quantity = 40
    end
    
    puts "✓ Created product listings"
  end
end

# Create sample expenses
if defined?(Expense)
  puts "\nCreating sample expenses..."
  
  3.times do |i|
    Expense.find_or_create_by(
      place: place1,
      owner_type: 'agency',
      amount: [1000000, 2000000, 3000000].sample,
      expense_date: rand(30).days.ago.to_date,
      description: "Operating expense #{i + 1}"
    )
  end
  
  puts "✓ Created sample expenses"
end

puts "\n" + "=" * 60
puts "✓ Seed data created successfully!"
puts "=" * 60

puts "\nLogin Credentials:"
puts "-" * 60
puts "Admin Portal (http://localhost:3000/admin/sign_in):"
puts "  Email: admin@sportify.com"
puts "  Password: password123"
puts ""
puts "Agency Portal (http://localhost:3000/agency/sign_in):"
puts "  Agency 1:"
puts "    Email: agency1@sportify.com"
puts "    Password: password123"
puts "    Manages: #{place1.name_en}, #{place2.name_en}"
puts ""
puts "  Agency 2:"
puts "    Email: agency2@sportify.com"
puts "    Password: password123"
puts "    Manages: #{place3.name_en}"
puts ""
puts "Customer Accounts:"
puts "  Customer 1: customer1@example.com / password123"
puts "  Customer 2: customer2@example.com / password123"
puts "-" * 60
