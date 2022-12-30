# frozen_string_literal: true

module UserInvitable
  extend ActiveSupport::Concern

  included do
    # invite token
    attribute :invite

    # Invitation callbacks
    before_validation :set_account_by_invitation, on: %i[create], if: :invite?
    after_create :accept_invite_after_create, if: :invite?

    # Non invitation callbacks
    after_create :create_account_user, unless: :invite?
    after_create :update_account_and_company, unless: :can_set_account_owner?
  end

  def invite?
    invite.present?
  end

  private

  def set_account_by_invitation
    return if account.present?

    skip_confirmation!
    @account_invitation = AccountInvitation.find_by(token: invite)
    self.account = @account_invitation.account
  end

  def accept_invite_after_create
    return if @account_invitation.blank?

    @account_invitation.accept!(self)
  end

  def can_set_account_owner?
    return false if invite?
    return false if account.owner.present?

    true
  end

  def update_account_and_company
    return if invite?
    return if account.owner.present?

    customer = Stripe::Customer.create({ email:, name: account.name, metadata: { user_email: email, user_name: name } })
    account.update!(owner: self, processor_customer_id: customer.id)
    account.company.update!(email:)
  end

  def create_account_user
    account.account_users.create!(user: self)
  end
end
