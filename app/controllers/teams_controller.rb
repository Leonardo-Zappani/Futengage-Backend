# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action  only: %i[show edit update destroy]

  # GET /teams
  def index
 
  end

  # GET /teams/1 or /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams or /teams.json
  def create
    @team = current_user.owned_teams.new(team_params)

    respond_to do |format|
      if @team.save
        notice = t('.success')
        redirect_to "/teams/" + @team.id.to_s
        format.json { render :show, status: :created, location: @team }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        notice = t('.success')
        format.json { render :show, status: :ok, location: @team }
        format.html { redirect_to teams_url, notice: notice }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to teams_url, notice: notice }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:group_name,:team_one_name, :team_two_name, :description)
  end
end
