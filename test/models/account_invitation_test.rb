# frozen_string_literal: true

# == Schema Information
#
# Table name: account_invitations
#
#  id            :bigint           not null, primary key
#  email         :string           not null
#  name          :string
#  role_cd       :integer          default(0), not null
#  token         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint           not null
#  invited_by_id :bigint           not null
#
# Indexes
#
#  index_account_invitations_on_account_id     (account_id)
#  index_account_invitations_on_invited_by_id  (invited_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (invited_by_id => users.id)
#

# class AccountInvitationTest < ActiveSupport::TestCase
#   test 'the truth' do
#     assert true
#   end
# end
