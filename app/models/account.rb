class Account < ApplicationRecord
  has_many :shops
end

# == Schema Information
#
# Table name: accounts
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
