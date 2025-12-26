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
  has_many :shipping_addresses
  has_many :orders

  has_one_attached :avatar do |attachable|
    attachable.variant :avatar_30, resize_to_fill: [30, 30]
    attachable.variant :avatar_100, resize_to_fill: [100, 100]
  end

  after_create_commit :attach_random_default_avatar, if: -> { !avatar.attached? }

  enum :gender, { male: 0, female: 1, other: 2 }

  scope :active, -> { where(is_locked: false) }

  def fullname
    names = [first_name, middle_name, last_name].compact_blank
    if I18n.locale == :vi
      names.reverse.join(' ')
    else
      names.join(' ')
    end
  end

  def admin?
    role&.name == 'admin'
  end

  def agency?
    role&.name == 'agency'
  end

  def avatar_url(size = :avatar_30)
    avatar.variant(size)
  end

  def self.ransackable_attributes(_auth = nil)
    %w[email name phone_number gender date_of_birth user_id role_id]
  end
  
  def self.ransackable_associations(_auth = nil)
    %w[role]
  end

  private

  def attach_random_default_avatar
    path = random_default_avatar_path
    return unless path
  
    avatar.attach(default_avatar_blob(path))
  end

  def random_default_avatar_path
    base = Rails.root.join('app/assets/images/default_avatars')

    folder =
      case gender
      when 'male' then 'male'
      when 'female' then 'female'
      else 'neutral'
      end

    Dir[base.join(folder, '*.{png,jpg}')].sample
  end

  def default_avatar_blob(path)
    ActiveStorage::Blob.find_or_create_by!(
      filename: File.basename(path),
      checksum: Digest::MD5.file(path).base64digest,
      byte_size: File.size(path),
      content_type: Marcel::MimeType.for(Pathname.new(path))
    ) do |blob|
      blob.upload File.open(path)
    end
  end
end
