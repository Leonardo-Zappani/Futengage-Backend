# frozen_string_literal: true

# == Schema Information
#
# Table name: audits
#
#  id              :bigint           not null, primary key
#  action          :string
#  associated_type :string
#  auditable_type  :string
#  audited_changes :jsonb
#  comment         :string
#  remote_address  :string
#  request_uuid    :string
#  user_type       :string
#  username        :string
#  version         :integer          default(0)
#  created_at      :datetime
#  account_id      :bigint
#  associated_id   :bigint
#  auditable_id    :bigint
#  user_id         :bigint
#
# Indexes
#
#  associated_index              (associated_type,associated_id)
#  auditable_index               (auditable_type,auditable_id,version)
#  index_audits_on_account_id    (account_id)
#  index_audits_on_created_at    (created_at)
#  index_audits_on_request_uuid  (request_uuid)
#  user_index                    (user_id,user_type)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Audit < Audited::Audit
  belongs_to :account, optional: true, default: -> { Current.account }
end
