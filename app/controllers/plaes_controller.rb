# frozen_string_literal: true

class PlaesController < ApplicationController
  before_action :set_plae, only: %i[show edit update destroy]

  # GET /plaes
  def index
    query = current_account.plaes.order(created_at: :asc)
    query = query.search_by_q(params[:q]) if params[:q].present?

    @pagy, @records = pagy(query)

    @records.load
  end

  # GET /plaes/1 or /plaes/1.json
  def show
  end

  # GET /plaes/new
  def new
    @plae = Plae.new
  end

  # GET /plaes/1/edit
  def edit
  end

  # POST /plaes or /plaes.json
  def create
    @plae = current_account.plaes.new(plae_params)

    respond_to do |format|
      if @plae.save
        notice = t('.success')
        format.html { redirect_to plaes_url, notice: notice }
        format.json { render :show, status: :created, location: @plae }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @plae.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plaes/1 or /plaes/1.json
  def update
    respond_to do |format|
      if @plae.update(plae_params)
        notice = t('.success')
        format.html { redirect_to plaes_url, notice: notice }
        format.json { render :show, status: :ok, location: @plae }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @plae.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plaes/1 or /plaes/1.json
  def destroy
    @plae.destroy
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to plaes_url, notice: notice }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plae
    @plae = current_account.plaes.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def plae_params
    params.fetch(:plae, {})
  end
end
