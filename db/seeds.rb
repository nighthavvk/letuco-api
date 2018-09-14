# frozen_string_literal: true

a = Account.create
s = Shop.create(name: 'Waakka', account_id: a.id)
# seller = Seller.create(name: 'Alina', account_id: a.id)
%w[pants bikini sunglasses hat].each { |n| Product.create(name: n, shop_id: s.id) }
