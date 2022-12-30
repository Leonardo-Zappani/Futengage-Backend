class AccountInvitationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show accept reject]
  before_action :set_account_invitation, only: %i[destroy update edit]
  before_action :set_account_invitation_by_token, only: %i[show accept reject]
  before_action :authenticate_user_with_invite!, only: %i[accept show]

  def index
    query = Current.account.account_invitations.order(:name)
    query = query.search_by_q(params[:q]) if params[:q].present?

    @pagy, @records = pagy(query)

    @records.load
  end

  def new
    @account_invitation = AccountInvitation.new
  end

  def show
    @account = @account_invitation.account
    @invited_by = @account_invitation.invited_by
  end

  def edit; end

  def create
    result = AccountInvitations::Create.call(
      account: Current.account,
      account_invitation_params:,
      invited_by: Current.user
    )

    respond_to do |format|
      if result.success?
        @account_invitation = result.account_invitation
        flash.now.notice = t('.success')
        format.html { redirect_to account_invitations_url(current_required_params) }
        format.json { render :show, status: :ok, location: result.account_invitation }
        format.turbo_stream
      else
        flash.now.alert = result.message
        format.turbo_stream { turbo_stream.update :flash, render(FlashComponent.new(flash:)) }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: result.account_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @account_invitation.update(account_invitation_params)
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

  def accept
    result = AccountInvitations::Accept.call(
      account_invitation: @account_invitation,
      user: Current.user
    )

    respond_to do |format|
      if result.success?
        flash.now.notice = t('.success')
        format.html { redirect_to root_path }
        format.json { render :show, status: :ok, location: @account_invitation }
        format.turbo_stream
      else
        flash.now.alert = result.message
        format.turbo_stream { turbo_stream.update :flash, render(FlashComponent.new(flash:)) }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account_invitation.errors, status: :unprocessable_entity }
      end
    end

    if result
      redirect_to root_path
    else
      message = @account_invitation.errors.full_messages.first || t('something_went_wrong')
      redirect_to account_invitation_path(@account_invitation), alert: message
    end
  end

  def reject
    @account_invitation.reject!
    redirect_to root_path
  end

  def destroy
    @account_invitation.destroy
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to account_invitations_url, notice: }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  def set_account_invitation_by_token
    @account_invitation = AccountInvitation.find_by!(token: params[:id])
    puts params[:id]
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: t('.not_found')
  end

  def set_account_invitation
    @account_invitation = Current.account.account_invitations.find(params[:id])
  end

  def account_invitation_params
    params.require(:account_invitation).permit(:email, :name, :role)
  end

  def authenticate_user_with_invite!
    return if user_signed_in?

    store_location_for(:user, request.fullpath)
    if User.exists?(email: @account_invitation.email)
      redirect_to new_user_session_path(invite: @account_invitation.token), alert: t('.authenticate')
    else
      redirect_to new_user_registration_path(invite: @account_invitation.token), alert: t('.register')
    end
  end
end
