# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id                        :bigint           not null, primary key
#  amount_cents              :bigint           default(0), not null
#  amount_currency           :string(3)        default("BRL"), not null
#  competency_date           :date
#  description               :text
#  document_number           :string
#  due_date                  :date             not null
#  exchanged_amount_cents    :bigint           default(0), not null
#  exchanged_amount_currency :string(3)        default("BRL"), not null
#  installment_number        :integer
#  installment_total         :integer
#  installment_type_cd       :integer
#  name                      :string
#  paid                      :boolean          default(FALSE), not null
#  paid_at                   :datetime
#  payment_method_cd         :integer          default(0), not null
#  payment_type_cd           :integer          default(0), not null
#  transaction_type_cd       :integer          default(0), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  account_id                :bigint           not null
#  bank_account_id           :bigint           not null
#  category_id               :bigint
#  contact_id                :bigint
#  cost_center_id            :bigint
#  import_id                 :bigint
#  installment_source_id     :bigint
#  transfer_to_id            :bigint
#
# Indexes
#
#  index_transactions_on_account_id             (account_id)
#  index_transactions_on_bank_account_id        (bank_account_id)
#  index_transactions_on_category_id            (category_id)
#  index_transactions_on_contact_id             (contact_id)
#  index_transactions_on_cost_center_id         (cost_center_id)
#  index_transactions_on_due_date               (due_date)
#  index_transactions_on_import_id              (import_id)
#  index_transactions_on_installment_source_id  (installment_source_id)
#  index_transactions_on_installment_type_cd    (installment_type_cd)
#  index_transactions_on_paid                   (paid)
#  index_transactions_on_payment_method_cd      (payment_method_cd)
#  index_transactions_on_payment_type_cd        (payment_type_cd)
#  index_transactions_on_transaction_type_cd    (transaction_type_cd)
#  index_transactions_on_transfer_to_id         (transfer_to_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (bank_account_id => bank_accounts.id)
#  fk_rails_...  (category_id => domains.id)
#  fk_rails_...  (contact_id => people.id)
#  fk_rails_...  (cost_center_id => domains.id)
#  fk_rails_...  (import_id => imports.id)
#  fk_rails_...  (installment_source_id => transactions.id)
#  fk_rails_...  (transfer_to_id => bank_accounts.id)
#
require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  setup do
    @transaction = transactions(:receipt_1)
  end

  test "should update an user" do
    time = Time.now
    @transaction.update!(
      due_date: time,
    )
    assert_equal @transaction.due_date.strftime("%d/%m/%Y"), time.strftime("%d/%m/%Y")
  end

  test "should find an user by ID" do
    transaction = Transaction.find(@transaction.id)
    assert_equal "User", transaction.account.users.name
  end
  test "should fail create an transaction" do
    assert_difference("transactions.count", 0) do
      Transaction.new(
        account: accounts(:account),
        bank_account: bank_accounts(:bank_one),
        contact: contacts(:contact_one),
        category: categories(:category_one),
        amount_cents: 0,
      )
    end
  end
end
