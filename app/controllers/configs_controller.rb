# frozen_string_literal: true

class ConfigsController < ApplicationController
  before_action :set_config, only: %i[show edit update destroy]

  # GET /configs
  def index
   
  end

  # GET /configs/1 or /configs/1.json
  def show
  end

  # GET /configs/new
  def new
    @config = Config.new
  end

  # GET /configs/1/edit
  def edit
  end

  # POST /configs or /configs.json
  def create
    @config = current_account.configs.new(config_params)

    respond_to do |format|
      if @config.save
        notice = t('.success')
        format.html { redirect_to configs_url, notice: notice }
        format.json { render :show, status: :created, location: @config }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /configs/1 or /configs/1.json
  def update
    respond_to do |format|
      if @config.update(config_params)
        notice = t('.success')
        format.html { redirect_to configs_url, notice: notice }
        format.json { render :show, status: :ok, location: @config }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /configs/1 or /configs/1.json
  def destroy
    @config.destroy
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to configs_url, notice: notice }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_config
    @config = current_account.configs.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def config_params
    params.fetch(:config, {})
  end
end
