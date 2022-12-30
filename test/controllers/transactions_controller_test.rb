# frozen_string_literal: true

require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transaction = transactions(:receipt_1)
    @user = users(:user_one)
    sign_in(@user)
  end

  test "should get index" do
    get transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_transaction_url
    assert_response :success
  end

  test "should create transaction" do
    assert_difference("Transaction.count") do
      post transactions_url,
           params: { transaction: { amount_cents: @transaction.amount_cents, amount_currency: @transaction.amount_currency,
                                   category_id: @transaction.category_id, contact_id: @transaction.contact_id, bank_account_id: @transaction.bank_account_id,
                                   cost_center_id: @transaction.cost_center_id, description: @transaction.description, due_date: @transaction.due_date,
                                   paid: @transaction.paid, paid_at: @transaction.paid_at, payment_method: @transaction.payment_method,
                                   payment_type: @transaction.payment_type, competency_date: @transaction.competency_date } }
    end

    assert_redirected_to transactions_url({ bank_account_id: @transaction.bank_account_id, month: Date.today.at_beginning_of_month, transaction_type: @transaction.transaction_type })
  end

  test "should show transaction" do
    get transactions_url(@transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_transaction_url(@transaction, { bank_account_id: @transaction.bank_account_id, month: @transaction.due_date, transaction_type: @transaction.transaction_type })
    assert_response :success
  end

  test "should update transaction" do
    patch transaction_url(@transaction),
          params: { transaction: { amount_cents: @transaction.amount_cents, amount_currency: @transaction.amount_currency,
                                  category_id: @transaction.category_id, contact_id: @transaction.contact_id, bank_account_id: @transaction.bank_account_id,
                                  cost_center_id: @transaction.cost_center_id, description: @transaction.description, due_date: @transaction.due_date,
                                  paid: @transaction.paid, paid_at: @transaction.paid_at, payment_method: @transaction.payment_method,
                                  payment_type: @transaction.payment_type, competency_date: @transaction.competency_date } }
    assert_redirected_to transactions_url({ bank_account_id: @transaction.bank_account_id, month: Date.today.at_beginning_of_month, transaction_type: @transaction.transaction_type })
  end

  test "should destroy transaction" do
    assert_difference("Transaction.count", -1) do
      delete transaction_url(@transaction, params: { option: :only_this_installment })
    end

    assert_redirected_to transactions_url({ bank_account_id: @transaction.bank_account_id, month: Date.today.at_beginning_of_month, transaction_type: @transaction.transaction_type })
  end

  # fails

  test "should get index:fail" do
    sign_out(@user)
    get transactions_url
    assert_response :found
  end

  test "should get new:fail" do
    sign_out(@user)
    get new_transaction_url
    assert_response :found
  end

  test "should not save a import" do
    transaction = Transaction.new
    assert_not transaction.save
  end

end
