# frozen_string_literal: true

class ImportsController < ApplicationController
  before_action :set_import, only: %i[show edit update destroy]

  # GET /imports
  def index
    authorize! :read, Import
    
    query = current_account.imports.order(created_at: :asc)
    query = query.search_by_q(params[:q]) if params[:q].present?

    @pagy, @records = pagy(query)

    @records.load
  end

  # GET /imports/1 or /imports/1.json
  def show
    authorize! :read, Import

    respond_to do |format|
      notice = I18n.t('imports.show.error')
      format.html { redirect_to imports_url, alert: notice }
      format.json { render json: @import.errors, status: :non_authoritative_information }
      format.turbo_stream { redirect_to imports_url, alert: notice }
    end
  end

  # GET /imports/new
  def new
    authorize! :create, Import

    @import = Import.new
  end

  # GET /imports/1/edit
  def edit; end

  # POST /imports or /imports.json
  def create
    authorize! :create, Import

    @import = current_account.imports.new(import_params)
    @import.state = :waiting
    @import.progress_total = 0
    @import.progress_number = 0
    respond_to do |format|
      if @import.save
        notice = t('.success')
        format.html { redirect_back_or_to imports_url, notice: }
        format.json { render :show, status: :created, location: @import }
        format.turbo_stream { redirect_back_or_to imports_url, notice: }
      else
        notice = t('imports.create.fail_import')
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @import.errors, status: :unprocessable_entity }
        format.turbo_stream { redirect_back_or_to imports_url, alert: notice }
      end
    end
  end

  # PATCH/PUT /imports/1 or /imports/1.json
  def update
    authorize! :update, Import

    respond_to do |format|
      notice = I18n.t('imports.update.error')
      format.html { redirect_to imports_url }
      format.json { render json: @import.errors, status: :unprocessable_entity }
      format.turbo_stream { redirect_to imports_url, alert: notice }
    end
  end

  # DELETE /imports/1 or /imports/1.json
  def destroy
    authorize! :destroy, Import

    @import.destroy
    respond_to do |format|
      notice = t('imports.destroy.success')
      format.html { redirect_to imports_url, alert: notice }
      format.turbo_stream { redirect_to imports_url, notice: }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_import
    @import = current_account.imports.find(params[:id])
  rescue StandardError => e
    respond_to do |format|
      notice = t('imports.find.error')
      format.html { redirect_to imports_url, alert: notice }
      format.json { head :no_content }
      format.turbo_stream { flash.now.alert = notice }
    end
  end

  # Only allow a list of trusted parameters through.
  def import_params
    params.require(:import).permit(:source, :state, :file)
  end
end
