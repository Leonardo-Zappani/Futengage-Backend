# frozen_string_literal: true

# == Schema Information
#
# Table name: bank_accounts
#
#  id                       :bigint           not null, primary key
#  account_type_cd          :integer          default(0), not null
#  balance_cents            :bigint           default(0), not null
#  balance_currency         :string(3)        default("BRL"), not null
#  default                  :boolean          default(FALSE), not null
#  initial_balance_cents    :bigint           default(0), not null
#  initial_balance_currency :string(3)        default("BRL"), not null
#  name                     :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  account_id               :bigint           not null
#
# Indexes
#
#  index_bank_accounts_on_account_id       (account_id)
#  index_bank_accounts_on_account_type_cd  (account_type_cd)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require "test_helper"

class BankAccountTest < ActiveSupport::TestCase
  setup do
    @bank_account = bank_accounts(:bank_one)
  end

  test "should create an bank" do
    bank_account = BankAccount.create(
      id: 1231,
      account: accounts(:account),
      default: true,
      name: "Bank_Test",
      created_at: Time.now,
      updated_at: Time.now,
      initial_balance_currency: "BRL",
      initial_balance_cents: 923,
      balance_currency: "BRL",
      account_type: :savings_account,
      balance_cents: 2323,
    )
    assert_equal "User", bank_account.account.users.name
    assert bank_account.default?
    assert_equal "Bank_Test", bank_account.name
    assert_not bank_account.current_account?
    assert bank_account.savings_account?
    assert_equal 2323, bank_account.balance_cents
    assert "BRL", bank_account.initial_balance_currency
  end

  test "should update an bank" do
    @bank_account.update!(
      default: false,
      name: "Bank_Test2",
    )
    assert_equal "User", @bank_account.account.users.name
    assert_not @bank_account.default?
    assert_equal "Bank_Test2", @bank_account.name
    assert @bank_account.current_account?
    assert_not @bank_account.savings_account?
    assert_equal 0, @bank_account.balance_cents
    assert "BRL", @bank_account.initial_balance_currency
  end

  test "should find an user by ID" do
    bank_account = BankAccount.find(@bank_account.id)
    assert_equal "User", bank_account.account.users.name
    assert_equal "one@FutEngage.io", bank_account.account.users.first.email
  end

  test "should create an bank:fail" do
    bank_account = BankAccount.new(
      id: 123912,
      default: nil,
      account: accounts(:account),
      name: nil,
    )
    assert_not BankAccount.exists?(bank_account.id)
  end
end
