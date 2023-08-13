# frozen_string_literal: true

class ConfirmationsController < ApplicationController
  before_action :authenticate_user!

  # GET /confirmations
  def index
    @confirmations = current_user.pending_confirmations

    render index: @confirmations, status: :ok
  end

  # GET /confirmations/1 or /confirmations/1.json
  def show
    render json: show, status: :ok
  end

  # POST /confirmations or /confirmations.json
  def create
    match = current_user.matches.find(confirmation_params[:match_id])

    @confirmation = match.confirmations.new(confirmation_params)

    if @confirmation.save
      render :show, status: :created, location: @confirmation
    else
      render json: @confirmation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /confirmations/1 or /confirmations/1.json
  def update
    @role = current_user.role

    @role = params[:role] if params[:role].present?
    @team_number = params[:team_number] if params[:team_number].present?

    @confirmation.update(confirmed: true, position: @role, team_number: @team_number)

    render show: @confirmation, status: :ok
  end

  # DELETE /confirmations/1 or /confirmations/1.json
  def destroy
    @confirmation.update(confirmed: false, active: false)

    render show: @confirmation, status: :ok
  end

  private

  # Only allow a list of trusted parameters through.
  def confirmation_params
    params.require(:confirmation).permit(:team_number, :position, :confirmed, :id, :match_id)
  end
end
