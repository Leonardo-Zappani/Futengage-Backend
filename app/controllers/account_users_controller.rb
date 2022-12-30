# frozen_string_literal: true

class AccountUsersController < ApplicationController
  before_action :ensure_frame_response, only: %i[new edit]
  before_action :set_account_user, only: %i[show edit update destroy]

  # GET /account_users or /account_users.json
  def index
    authorize! :read, AccountUser

    query = Current.account.account_users.includes(:user, :account).order('users.first_name ASC, users.last_name ASC')
    query = query.search_by_q(params[:q]) if params[:q].present?

    @pagy, @records = pagy(query)

    @records.load
  end

  # GET /account_users/1 or /account_users/1.json
  def show; end

  # GET /account_users/new
  def new
    # @account_user = AccountUser.new
  end

  # GET /account_users/1/edit
  def edit; end

  # POST /account_users or /account_users.json
  def create
    # @account_user = current_account.account_users.new(account_user_params)
    #
    # respond_to do |format|
    #   if @account_user.save
    #     notice = t('.success')
    #     format.html { redirect_to account_users_url, notice: }
    #     format.json { render :show, status: :created, location: @account_user }
    #     format.turbo_stream { flash.now.notice = notice }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @account_user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /account_users/1 or /account_users/1.json
  def update
    respond_to do |format|
      if @account_user.update(account_user_params)
        notice = t('.success')
        format.html { redirect_to account_users_url, notice: }
        format.json { render :show, status: :ok, location: @account_user }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_users/1 or /account_users/1.json
  def destroy
    @account_user.destroy_or_discard
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to account_users_url, notice: }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account_user
    @account_user = current_account.account_users.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def account_user_params
    params.require(:account_user).permit(:role)
  end
end
