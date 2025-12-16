class PlaceManager < ApplicationRecord
  belongs_to :user
  belongs_to :place

  def self.ransackable_associations(_auth = nil)
    %w[user place]
  end
end
