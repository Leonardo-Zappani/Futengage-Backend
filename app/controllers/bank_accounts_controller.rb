# frozen_string_literal: true

class BankAccountsController < ApplicationController
  before_action :set_bank_account, only: %i[show edit update destroy turn_default]

  # GET /bank_accounts
  def index
    authorize! :read, BankAccount

    query = current_account.bank_accounts.order(created_at: :asc)
    query = query.search_by_q(params[:q]) if params[:q].present?

    @pagy, @records = pagy(query)

    @records.load
  end

  # GET /bank_accounts/1 or /bank_accounts/1.json
  def show; end

  # GET /bank_accounts/new
  def new
    authorize! :create, BankAccount

    @bank_account = BankAccount.new
  end

  # GET /bank_accounts/1/edit
  def edit; end

  # POST /bank_accounts or /bank_accounts.json
  def create
    authorize! :create, BankAccount

    @bank_account = current_account.bank_accounts.new(bank_account_params.merge(default: false))

    respond_to do |format|
      if @bank_account.save
        notice = t('.success')
        format.html { redirect_to bank_accounts_url, notice: }
        format.json { render :show, status: :created, location: @bank_account }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_accounts/1/turn_default or /bank_accounts/1/turn_default.json
  def turn_default
    authorize! :update, BankAccount

    respond_to do |format|
      @bank_account.other_bank_accounts.update_all(default: false)
      if @bank_account.update(default: true)
        notice = t('.success')
        format.html { redirect_to bank_accounts_url, notice: }
        format.json { render :show, status: :ok, location: @bank_account }
        format.turbo_stream { flash.now.notice = notice }
      else
        flash.now.alert = @bank_account.errors.full_messages.first
        format.turbo_stream { turbo_stream.update :flash, render(FlashComponent.new(flash:)) }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_accounts/1 or /bank_accounts/1.json
  def update
    authorize! :update, BankAccount

    respond_to do |format|
      if @bank_account.update(bank_account_params)
        notice = t('.success')
        format.html { redirect_to bank_accounts_url, notice: }
        format.json { render :show, status: :ok, location: @bank_account }
        format.turbo_stream { flash.now.notice = notice }
      else
        flash.now.alert = @bank_account.errors.full_messages.first
        format.turbo_stream { turbo_stream.update :flash, render(FlashComponent.new(flash:)) }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_accounts/1 or /bank_accounts/1.json
  def destroy
    authorize! :destroy, BankAccount

    @bank_account.destroy
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to bank_accounts_url, notice: }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bank_account
    @bank_account = current_account.bank_accounts.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bank_account_params
    params.require(:bank_account).permit(:name, :account_type, :balance_cents, :balance_currency,
                                         :initial_balance_cents, :initial_balance_currency, :default)
  end
end
