# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :account
end

# == Schema Information
#
# Table name: customers
#
#  id         :bigint(8)        not null, primary key
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
