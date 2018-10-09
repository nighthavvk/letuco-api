class Product < ApplicationRecord
  belongs_to :shop
  has_and_belongs_to_many :orders

  validates :name, presence: true
  validates :name, uniqueness: { scope: :shop_id }
end

# == Schema Information
#
# Table name: products
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  shop_id    :bigint(8)
#
# Indexes
#
#  index_products_on_shop_id  (shop_id)
#
# Foreign Keys
#
#  fk_rails_...  (shop_id => shops.id)
#
