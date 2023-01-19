# frozen_string_literal: true

class HistoriesController < ApplicationController
  before_action :set_history, only: %i[show edit update destroy]
  
  include SetCurrent
  
  before_action :current_teams
  before_action :current_match
  before_action :list_match
  before_action :current_confirmation
  before_action :current_member
  before_action :current_player_count
  before_action :current_peding_confirmation
  before_action :all_matches

  # GET /histories

  def all_matches
    @all_matches = Confirmation.joins(:match, team: :members).where(members: {user_id: current_user.id})
  end

  def member_ids
    @member_ids = current_user.teams.map{|t| t.members.pluck(:id) }.flatten
  end

  def teams
   @all_teamss = Member.where(user_id: current_user.id).map(&:team)
  end

  

  def index
   
  end

  # GET /histories/1 or /histories/1.json
  def show
  end

  # GET /histories/new
  def new
    @history = History.new
  end

  # GET /histories/1/edit
  def edit
  end

  # POST /histories or /histories.json
  def create
    @history = current_account.histories.new(history_params)

    respond_to do |format|
      if @history.save
        notice = t('.success')
        format.html { redirect_to histories_url, notice: notice }
        format.json { render :show, status: :created, location: @history }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /histories/1 or /histories/1.json
  def update
    respond_to do |format|
      if @history.update(history_params)
        notice = t('.success')
        format.html { redirect_to histories_url, notice: notice }
        format.json { render :show, status: :ok, location: @history }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /histories/1 or /histories/1.json
  def destroy
    @history.destroy
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to histories_url, notice: notice }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_history
    @history = current_account.histories.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def history_params
    params.fetch(:history, {})
  end
end
