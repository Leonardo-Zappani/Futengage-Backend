# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :ensure_frame_response, only: %i[new edit]
  before_action :set_category, only: %i[show edit update destroy]

  # GET /categories or /categories.json
  def index
    authorize! :read, Category

    query = current_account.categories.sort_by_params(sort_column(Category, default: :name), sort_direction)
    query = query.search_by_q(params[:q]) if params[:q].present?

    @pagy, @records = pagy(query)

    @records.load
  end

  # GET /categories/1 or /categories/1.json
  def show
    authorize! :read, Category
  end

  # GET /categories/new
  def new
    authorize! :create, Category
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    authorize! :update, Category
  end

  # POST /categories or /categories.json
  def create
    authorize! :create, Category

    @category = current_account.categories.new(category_params)
    respond_to do |format|
      if @category.save
        notice = t('.success')
        format.html { redirect_to categories_url, notice: }
        format.json { render :show, status: :created, location: @category }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    authorize! :update, Category

    respond_to do |format|
      if @category.update(category_params)
        notice = t('.success')
        format.html { redirect_to categories_url, notice: }
        format.json { render :show, status: :ok, location: @category }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    authorize! :destroy, Category

    @category.destroy_or_discard
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to categories_url, notice: }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = current_account.categories.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def category_params
    params.require(:category).permit(:name, :description)
  end
end
