# frozen_string_literal: true

class AccountSettingsController < ApplicationController
  before_action :ensure_frame_response, only: %i[edit]
  before_action :set_account, only: %i[edit update]

  # GET /account_settings/edit
  def edit; end

  # PATCH/PUT /account_settings or /account_settings/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        notice = t('.success')
        format.html { redirect_to root_path, notice: }
        format.json { render :show, status: :ok, location: @account }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Current.account
  end

  # Only allow a list of trusted parameters through.
  def account_params
    params.require(:account).permit(
      :default_currency,
      :country_code,
      :processor_plan_id,
      { company_attributes: %i[id name document_1 document_2 email phone_number description avatar] }
    )
  end
end
