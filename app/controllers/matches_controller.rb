# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]

  # GET /matches
  def index
    query = current_account.matches.order(created_at: :asc)
    query = query.search_by_q(params[:q]) if params[:q].present?

    @pagy, @records = pagy(query)

    @records.load
  end

  # GET /matches/1 or /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches or /matches.json
  def create
    @team = Team.find(params[:match][:team_id])
    @place = Place.find(params[:match][:place_id])
    puts @place 
    puts @team
    
    @match = @team.matches.new(scheduled_at: params[:match][:scheduled_at], place: @place, owner_id: params[:match][:owner_id], team_one_name: params[:match][:team_one_name], team_two_name: params[:match][:team_two_name], team_one_score: params[:match][:team_one_score], team_two_score: params[:match][:team_two_score], confirmed_at: params[:match][:confirmed_at])
      respond_to do |format|
        if @match.save
          notice = t('.success')
          format.html { redirect_to matches_url, notice: notice }
          format.json { render :show, status: :created, location: @match }
          format.turbo_stream { flash.now.notice = notice }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        notice = t('.success')
        format.html { redirect_to matches_url, notice: notice }
        format.json { render :show, status: :ok, location: @match }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1 or /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to matches_url, notice: notice }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = current_account.matches.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:scheduled_at, :team_id, :place_id, :owner_id, :team_one_name, :team_two_name, :team_one_score, :team_two_score, :confirmed_at)
  end
end
