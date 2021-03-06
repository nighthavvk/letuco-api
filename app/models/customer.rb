class Customer < ApplicationRecord
  belongs_to :account
  has_many :orders

  validates :name, presence: true
  validates :name, uniqueness: { scope: :account_id }
end

# == Schema Information
#
# Table name: customers
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint(8)
#
# Indexes
#
#  index_customers_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
