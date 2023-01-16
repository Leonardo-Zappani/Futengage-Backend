# frozen_string_literal: true

class PagamentosController < ApplicationController
  before_action :set_pagamento, only: %i[show edit update destroy]

  # GET /pagamentos
  def index
    query = current_account.pagamentos.order(created_at: :asc)
    query = query.search_by_q(params[:q]) if params[:q].present?

    @pagy, @records = pagy(query)

    @records.load
  end

  # GET /pagamentos/1 or /pagamentos/1.json
  def show
  end

  # GET /pagamentos/new
  def new
    @pagamento = Pagamento.new
  end

  # GET /pagamentos/1/edit
  def edit
  end

  # POST /pagamentos or /pagamentos.json
  def create
    @pagamento = current_account.pagamentos.new(pagamento_params)

    respond_to do |format|
      if @pagamento.save
        notice = t('.success')
        format.html { redirect_to pagamentos_url, notice: notice }
        format.json { render :show, status: :created, location: @pagamento }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pagamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pagamentos/1 or /pagamentos/1.json
  def update
    respond_to do |format|
      if @pagamento.update(pagamento_params)
        notice = t('.success')
        format.html { redirect_to pagamentos_url, notice: notice }
        format.json { render :show, status: :ok, location: @pagamento }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pagamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pagamentos/1 or /pagamentos/1.json
  def destroy
    @pagamento.destroy
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to pagamentos_url, notice: notice }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pagamento
    @pagamento = current_account.pagamentos.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pagamento_params
    params.fetch(:pagamento, {})
  end
end
