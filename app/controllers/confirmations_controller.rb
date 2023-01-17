# frozen_string_literal: true

class ConfirmationsController < ApplicationController
  before_action :set_confirmation, only: %i[show edit update destroy]

  # GET /confirmations
  def index
    query = current_account.confirmations.order(created_at: :asc)
    query = query.search_by_q(params[:q]) if params[:q].present?

    @pagy, @records = pagy(query)

    @records.load
  end

  # GET /confirmations/1 or /confirmations/1.json
  def show
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
    @confirmation.update(confirmed: true)
    redirect_to root_path
  end

  # DELETE /confirmations/1 or /confirmations/1.json
  def destroy
    @confirmation.destroy
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to confirmations_url, notice: notice }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_confirmation
    @confirmation = current_user.teams.joins(:matches).where("matches.scheduled_at > ?", Time.now).order("matches.scheduled_at ASC").first.matches.where("matches.scheduled_at > ?", Time.now).order("matches.scheduled_at ASC").first.confirmations.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def confirmation_params
    params.fetch(:confirmation, {})
  end
end
