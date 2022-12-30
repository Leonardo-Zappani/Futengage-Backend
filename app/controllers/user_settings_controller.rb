# frozen_string_literal: true

class UserSettingsController < ApplicationController
  before_action :ensure_frame_response, only: %i[edit]
  before_action :set_user, only: %i[edit update switch_account]

  # GET /user_settings/edit
  def edit; end

  # PATCH/PUT /user_settings or /user_settings/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        notice = t('.success')
        format.html { redirect_to root_path, notice: }
        format.json { render :show, status: :ok, location: @user }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_settings or /user_settings.json
  def switch_account
    respond_to do |format|
      if @user.update(switch_account_params)
        notice = t('.success')
        format.html { redirect_to root_path, notice: }
        format.json { render :show, status: :ok, location: @user }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = Current.user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    user_settings_params = %i[first_name last_name email preferred_language time_zone avatar account_id]
    if params[:user][:password].present? || params[:user][:password_confirmation].present?
      user_settings_params << :password
      user_settings_params << :password_confirmation
    end
    params.require(:user).permit(user_settings_params)
  end

  def switch_account_params
    params.require(:user).permit(:account_id)
  end
end
