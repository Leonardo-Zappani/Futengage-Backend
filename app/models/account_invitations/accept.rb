module AccountInvitations
  class Accept < ApplicationInteractor
    def call
      account_user = context.account_invitation.accept!(context.user)
      if account_user.present?
        context.account_user = account_user
      else
        context.fail!(message: account_user.errors.full_messages.first)
      end
    end
  end
end
