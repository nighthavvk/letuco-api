class Order < ApplicationRecord
  belongs_to :seller
  belongs_to :customer
  has_and_belongs_to_many :products

  validates :seller_id, :status, presence: true
end

# == Schema Information
#
# Table name: orders
#
#  id          :bigint(8)        not null, primary key
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint(8)
#  seller_id   :bigint(8)
#
# Indexes
#
#  index_orders_on_customer_id  (customer_id)
#  index_orders_on_seller_id    (seller_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (seller_id => sellers.id)
#
