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
  has_many :requested_stock_requests, class_name: 'StockRequest', foreign_key: 'requested_by_id'
  has_many :approved_stock_requests, class_name: 'StockRequest', foreign_key: 'approved_by_id'
  has_many :stock_transfers, foreign_key: 'transferred_by_id'

  enum :gender, { male: 0, female: 1, other: 2 }

  has_one_attached :avatar do |attachable|
    attachable.variant :avatar_30, resize_to_fill: [30, 30]
    attachable.variant :avatar_100, resize_to_fill: [100, 100]
  end

  after_create_commit :attach_random_default_avatar, if: -> { !avatar.attached? }

  validates :birthday, timeliness: { on_or_before: -> { Date.current } }, allow_nil: true

  scope :active, -> { where(is_locked: false) }
  scope :deleted, -> { where(is_locked: true) }
  scope :by_role_agency, -> {
    joins(:role).where(roles: { name: 'agency' })
  }

  def full_name
    names = [first_name, middle_name, last_name].compact_blank
    if I18n.locale == :vi
      names.reverse.join(' ')
    else
      names.join(' ')
    end
  end

  def role_name
    role&.name || ''
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

  ransacker :full_name do |parent|
    Arel.sql("CONCAT(first_name, ' ', middle_name, ' ', last_name)")
  end

  def self.ransackable_attributes(_auth = nil)
    %w[email name phone gender date_of_birth user_id role_id full_name
    username created_at updated_at]
  end
  
  def self.ransackable_associations(_auth = nil)
    %w[role]
  end

  private

  def attach_random_default_avatar
    path = random_default_avatar_path
    return unless path && File.exist?(path)

    avatar.attach(
      io: File.open(path),
      filename: File.basename(path),
      content_type: Marcel::MimeType.for(Pathname.new(path))
    )
  end

  def random_default_avatar_path
    base = Rails.root.join('app/assets/images/default_avatars')

    folder =
      if male?
        'male'
      elsif female?
        'female'
      else
        'neutral'
      end

    Dir[base.join(folder, '*.{png,jpg}')].sample
  end
end
