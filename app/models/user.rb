class User < ApplicationRecord
  self.primary_key = "user_id"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  belongs_to :role, optional: true
  
  has_many :bookings
  has_many :recurring_bookings
  has_many :payments
  has_many :notifications
  has_many :posts
  has_many :reviews
  has_many :place_managers

  # enum gender: { male: 0, female: 1, other: 2 }

  def fullname
    names = [first_name, middle_name, last_name].compact_blank
    if I18n.locale == :vi
      names.reverse.join(' ')
    else
      names.join(' ')
    end
  end
end
