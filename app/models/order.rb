# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :shop
  belongs_to :seller

  # has_and_belongs_to_many :products
end

# == Schema Information
#
# Table name: orders
#
#  id         :bigint(8)        not null, primary key
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  seller_id  :bigint(8)
#  shop_id    :bigint(8)
#
# Indexes
#
#  index_orders_on_seller_id  (seller_id)
#  index_orders_on_shop_id    (shop_id)
#
# Foreign Keys
#
#  fk_rails_...  (seller_id => sellers.id)
#  fk_rails_...  (shop_id => shops.id)
#
