class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :created_at

  belongs_to :seller
  belongs_to :customer
  has_many :products
end
