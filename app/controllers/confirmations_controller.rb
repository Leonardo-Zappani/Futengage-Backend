# frozen_string_literal: true

class ConfirmationsController < ApplicationController
  before_action :set_confirmation, only: %i[show edit update destroy]

  # GET /confirmations
  def index
    @confirmations = current_user.futengage.confirmations.where(confirmed: false, confirmed_at: nil)
  end

  # GET /confirmations/1 or /confirmations/1.json
  def show
    render json: show, status: :ok
  end


  # GET /confirmations/new
  def new
    @confirmation = Confirmation.new
  end

  # GET /confirmations/1/edit
  def edit
  end

  # POST /confirmations or /confirmations.json
  def create
    @confirmation = current_account.confirmations.new(confirmation_params)

    respond_to do |format|
      if @confirmation.save
        notice = t('.success')
        format.html { redirect_to confirmations_url, notice: notice }
        format.json { render :show, status: :created, location: @confirmation }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @confirmation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /confirmations/1 or /confirmations/1.json
  def update
    @role = current_user.role
    if params[:role].present?
      @role = params[:role]
      @team_number = params[:team_number]
    end
    @confirmation.update(confirmed: true, position: @role, team_number: @team_number)
    redirect_to "/home?id=#{params[:id]}"
  end

  # DELETE /confirmations/1 or /confirmations/1.json
  def destroy
    @confirmation.update(confirmed: false)
    redirect_to "/home?id=#{params[:id]}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_confirmation
    if params[:id].present?
      @confirmation = Confirmation.find(params[:id])
    else
      @confirmation = current_user.teams.joins(:matches).where("matches.scheduled_at > ?", Time.now-84640).order("matches.scheduled_at ASC").first.matches.where("matches.scheduled_at > ?", Time.now-84640).order("matches.scheduled_at ASC").first.confirmations.find(params[:id])
    end 
  end

  # Only allow a list of trusted parameters through.
  def confirmation_params
    params.require(:confirmation).permit(:team_number, :position, :confirmed, :id)
  end
end
