class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :shop
  belongs_to :orders
end
