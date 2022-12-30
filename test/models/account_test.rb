# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id                    :bigint           not null, primary key
#  account_type_cd       :integer          default(0), not null
#  admin                 :boolean          default(FALSE), not null
#  balance_cents         :bigint           default(0), not null
#  balance_currency      :string(3)        default("BRL"), not null
#  country_code          :string(2)        default("BR")
#  default_currency      :string(3)        default("BRL")
#  discarded_at          :datetime
#  processor_plan_name   :string
#  subscription_status   :string           default("incomplete")
#  trial_ends_at         :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  company_id            :bigint           not null
#  owner_id              :bigint
#  processor_customer_id :string
#  processor_plan_id     :string
#
# Indexes
#
#  index_accounts_on_company_id    (company_id)
#  index_accounts_on_discarded_at  (discarded_at)
#  index_accounts_on_owner_id      (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => people.id)
#  fk_rails_...  (owner_id => users.id)
#
require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  setup do
    accounts(:account)
  end
  test 'the truth' do
    assert true
  end
end
