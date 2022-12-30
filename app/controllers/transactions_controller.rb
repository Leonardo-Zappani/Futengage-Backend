# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :ensure_frame_response,
                only: %i[show edit update destroy duplicate toggle details move_to create_installments
                         create_recurrence]
  before_action :set_transaction,
                only: %i[show edit update destroy duplicate toggle details move_to create_installments
                         create_recurrence setup_installments setup_recurrence destroy_dialog]
  before_action :set_current_month
  before_action :set_current_bank_account
  before_action :set_current_transaction_type
  before_action :set_current_required_params

  attr_reader :current_transaction_type, :current_bank_account, :current_month, :current_required_params,
              :current_period

  helper_method :current_month, :current_bank_account, :current_transaction_type, :current_required_params

  # GET /transactions or /transactions.json
  def index
    authorize! :read, Transaction

    @records = Transactions::Search.call(
      account: Current.account,
      bank_account: current_bank_account,
      period: current_month.all_month,
      transaction_type: current_transaction_type.to_sym,
      q: params[:q],
      sort_column: sort_column(Transaction, default: :due_date),
      sort_direction:
    ).query

    @records.load
  end

  # GET /transactions/totalizer
  def totalizer
    authorize! :read, Transaction

    @total, @total_paid, @total_unpaid = Transactions::Totalizer.call(
      account: Current.account,
      bank_account: current_bank_account,
      period: current_month.all_month,
      transaction_type: current_transaction_type.to_sym
    ).result
  end

  # GET /transactions/outcome
  def outcome
    authorize! :read, Transaction

    @outcome = Transactions::Outcome.call(
      account: Current.account,
      bank_account: current_bank_account,
      period: current_month.all_month
    ).result
  end

  # GET /transactions/revenues
  def revenues
    authorize! :read, Transaction

    @paid_revenues, @expected_revenues, @percentage = Transactions::Revenues.call(
      account: Current.account,
      bank_account: current_bank_account,
      period: current_month.all_month
    ).result
  end

  # GET /transactions/expenses
  def expenses
    authorize! :read, Transaction

    @paid_expenses, @expected_expenses, @percentage = Transactions::Expenses.call(
      account: Current.account,
      bank_account: current_bank_account,
      period: current_month.all_month
    ).result
  end

  # GET /transactions/chart
  def chart
    authorize! :read, Transaction

    range_of_months = (current_month - 1.month).beginning_of_month..(current_month + 1.month).end_of_month
    @column_data, @line_data = Transactions::Chart.call(
      account: Current.account,
      bank_account: current_bank_account,
      range_of_months:,
      period: :month
    ).result
  end

  # GET /transactions/balance
  def balance; end

  # GET /transactions/1 or /transactions/1.json
  def show
    authorize! :update, Transaction
  end

  # GET /transactions/new
  def new
    authorize! :create, Transaction

    @transaction = current_account.transactions.new(
      due_date: current_month.change(day: Date.current.day),
      bank_account: current_bank_account,
      transaction_type: current_transaction_type,
      amount_currency: Money.default_currency
    )
  end

  # GET /transactions/add
  def add; end

  # GET /transactions/1/edit
  def edit
    return unless @transaction.notifications_as_transaction.unread.exists?

    @transaction.notifications_as_transaction.unread.mark_as_read!
  end

  # GET /transactions/1/move_to
  def move_to; end

  # GET /transactions/1/details
  def details
    return unless @transaction.notifications_as_transaction.unread.exists?

    @transaction.notifications_as_transaction.unread.mark_as_read!
  end

  def setup_installments
    @transaction.installment_type = :monthly
    @transaction.installment_total = 3
  end

  def setup_recurrence
    @transaction.installment_type = :monthly
    @transaction.installment_total = 12
  end

  # POST /transactions or /transactions.json
  def create
    authorize! :create, Transaction

    result = Transactions::Create.call(
      account: Current.account,
      transaction_params: transaction_params.except(:payment_type)
    )

    @transaction = result.transaction
    @selected_payment_type = transaction_params.fetch(:payment_type, :on_cash).to_sym if @transaction.on_cash?

    build_response(result:)
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    authorize! :update, Transaction

    result = Transactions::Update.call(
      account: Current.account,
      transaction: @transaction,
      transaction_params: transaction_params.except(:payment_type)
    )

    @transaction = result.transaction
    @selected_payment_type = transaction_params.fetch(:payment_type, :on_cash).to_sym if @transaction.on_cash?

    build_response(result:)
  end

  def toggle
    authorize! :update, Transaction

    result = Transactions::Toggle.call(account: Current.account, transaction: @transaction)

    @transaction = result.transaction

    build_response(result:)
  end

  # PUT/PATCH /transactions/1/duplicate
  def duplicate
    authorize! :update, Transaction

    result = Transactions::Duplicate.call(account: Current.account, transaction: @transaction)

    @source_transaction = @transaction
    @transaction = result.transaction

    build_response(result:)
  end

  # PUT/PATCH /transactions/1/create_installments
  def create_installments
    authorize! :update, Transaction

    result = Transactions::CreateInstallments.call(
      account: Current.account,
      transaction: @transaction,
      create_installments_params:
    )

    @transaction = result.transaction

    build_response(result:)
  end

  # PUT/PATCH /transactions/1/create_recurrence
  def create_recurrence
    authorize! :update, Transaction

    result = Transactions::CreateRecurrence.call(
      account: Current.account,
      transaction: @transaction,
      create_recurrence_params:
    )

    @transaction = result.transaction

    build_response(result:)
  end

  def destroy_dialog; end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    authorize! :destroy, Transaction

    result = Transactions::Destroy.call(
      account: Current.account,
      transaction: @transaction,
      option: params.require(:option)
    )

    @transaction = result.transaction

    build_response(result:)
  end

  private

  # Callbacks
  def set_current_month
    @current_month = if params[:month].present?
                       Date.parse(params[:month].to_s).beginning_of_month
                     else
                       Current.date.beginning_of_month
                     end
  end

  def set_current_bank_account
    @current_bank_account = if params[:bank_account_id].present?
                              current_account.bank_accounts.find(params[:bank_account_id])
                            else
                              current_account.default_bank_account
                            end
  end

  def set_current_transaction_type
    transaction_type = params[:transaction_type]&.to_sym
    @current_transaction_type = if transaction_type_defined?
                                  transaction_type
                                else
                                  :revenue
                                end
  end

  def set_current_required_params
    @current_required_params = {
      bank_account_id: current_bank_account&.id,
      month: current_month,
      transaction_type: current_transaction_type
    }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Current.account.transactions.with_attached_attachments.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(
      :bank_account_id, :contact_id, :category_id, :cost_center_id, :transaction_type,
      :name, :description, :payment_method, :payment_type, :paid, :paid_at, :due_date,
      :competency_date, :paid_at, :amount_cents, :amount_currency, :amount_cents, :amount_currency, :installment_total,
      :installment_type, :payment_type, :exchanged_amount_cents, :document_number, :transfer_to_id,
      tag_list: [], attachments: []
    )
  end

  def payment_type_params
    params.require(:transaction).permit(:payment_type)
  end

  def create_installments_params
    params.require(:transaction).permit(
      :amount_cents, :amount_currency, :installment_total, :installment_type, :payment_type
    )
  end

  def create_recurrence_params
    params.require(:transaction).permit(
      :amount_cents, :amount_currency, :installment_total, :installment_type, :payment_type
    )
  end

  def transaction_types
    @transaction_types ||= Transaction.transaction_types
  end

  def transaction_type_defined?
    transaction_type = params[:transaction_type]&.to_sym
    transaction_type.present? && transaction_types.include?(transaction_type)
  end

  def build_response(result:)
    respond_to do |format|
      if result.success?
        build_response_success(result:, format:)
      else
        build_response_fail(result:, format:)
      end
    end
  end

  def build_response_success(result:, format:)
    current_bank_account.reload
    flash.now.notice = result.message
    format.html { redirect_to transactions_url(current_required_params) }
    format.json { render :show, status: :ok, location: @transaction }
    format.turbo_stream
  end

  def build_response_fail(result:, format:)
    flash.now.alert = result.message
    format.turbo_stream { turbo_stream.update :flash, render(FlashComponent.new(flash:)) }
    format.html { render :index, status: :unprocessable_entity }
    format.json { render json: result.transaction.errors, status: :unprocessable_entity }
  end
end
