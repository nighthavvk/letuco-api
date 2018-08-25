# frozen_string_literal: true

class Seller < ApplicationRecord
  belongs_to :account
end

# == Schema Information
#
# Table name: sellers
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint(8)
#
# Indexes
#
#  index_sellers_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
