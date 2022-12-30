# frozen_string_literal: true

# == Schema Information
#
# Table name: account_users
#
#  id         :bigint           not null, primary key
#  role_cd    :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_account_users_on_account_id  (account_id)
#  index_account_users_on_role_cd     (role_cd)
#  index_account_users_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#
class AccountUser < ApplicationRecord
  include Auditable

  ROLES = {
    admin: 0,
    user: 1,
    read_only: 2
  }.freeze

  scope :admin, -> { where(role_cd: ROLES[:admin]) }

  as_enum :role, ROLES

  belongs_to :account
  belongs_to :user

  before_validation :set_default_role

  def others
    account.account_users.where.not(id:)
  end

  def owner?
    account.owner_id == user_id
  end

  private

  def set_default_role
    return if role.present?

    self.role = default_role
  end

  def exists_any_account_user?
    account.account_users.exists?
  end

  def default_role
    return :user if exists_any_account_user?

    :admin
  end
end
