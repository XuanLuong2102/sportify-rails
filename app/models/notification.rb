class Notification < ApplicationRecord
  include LocalizedAttributes

  belongs_to :user

  localized_attr :title, :content, fallback: [:vi, :en]
end
