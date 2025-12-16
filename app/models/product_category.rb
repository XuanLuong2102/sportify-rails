class ProductCategory < ApplicationRecord
  has_many :products, foreign_key: :category_id, dependent: :nullify

  localize_attr :name, :description
end
