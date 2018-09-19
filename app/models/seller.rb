# frozen_string_literal: true

class Seller < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :invitable # , :omniauthable
  include DeviseTokenAuth::Concerns::User

  before_validation :handle_new_account, on: :create
  before_invitation_created :handle_invited_account

  belongs_to :account

  def admin?
    role == 'admin'
  end

  private

  def handle_new_account
    self.account = Account.new
    self.role = 'admin'
  end

  def handle_invited_account
    self.account = invited_by.account
  end
end

# == Schema Information
#
# Table name: sellers
#
#  id                     :bigint(8)        not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  nickname               :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string
#  sign_in_count          :integer          default(0), not null
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :bigint(8)
#  invited_by_id          :bigint(8)
#
# Indexes
#
#  index_sellers_on_account_id                         (account_id)
#  index_sellers_on_confirmation_token                 (confirmation_token) UNIQUE
#  index_sellers_on_email                              (email) UNIQUE
#  index_sellers_on_invitation_token                   (invitation_token) UNIQUE
#  index_sellers_on_invitations_count                  (invitations_count)
#  index_sellers_on_invited_by_id                      (invited_by_id)
#  index_sellers_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_sellers_on_reset_password_token               (reset_password_token) UNIQUE
#  index_sellers_on_uid_and_provider                   (uid,provider) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
