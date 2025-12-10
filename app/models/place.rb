class Place < ApplicationRecord
  include Localizable

  self.primary_key = 'place_id'

  has_many :place_sports
  has_many :place_managers

  localize_attr :name, :address, :description

  ransacker :name do |parent|
    Arel.sql("CONCAT(name_en, ' ', name_vi)")
  end

  ransacker :location do |parent|
     Arel.sql("CONCAT(city_en, ' ', city_vi, ' ', district_en, ' ', district_vi)")
  end

  def self.ransackable_attributes(auth_object = nil)
    ['address_en', 'address_vi', 'city_en', 'city_vi', 'district_en', 'district_vi', 
     'name_en', 'name_vi', 'is_close', 'maintenance_place', 'name', 'location']
  end

  def self.ransackable_associations(auth_object = nil)
    ['place_sports']
  end
end
