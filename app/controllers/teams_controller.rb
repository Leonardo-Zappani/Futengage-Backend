# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action  only: %i[show edit update destroy]

  # GET /teams
  def index
    @teams = Team.all
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

  # POST /teams/create_match 
  def create_match
    puts params
    @team = Team.find(params[:team_id])
    @place = Place.where("name = ?", params[:place_id]).first
    @match = @team.matches.new(scheduled_at: params[:scheduled_at], place: @place, owner_id: params[:owner_id], team_one_name: params[:team_one_name], team_two_name: params[:team_two_name], team_one_score: params[:team_one_score], team_two_score: params[:team_two_score], confirmed_at: params[:confirmed_at])
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


  # POST /teams/create_place
  def create_place
    @team = Team.find(params[:team_id])
    @place = @team.places.create(place_params)
    redirect_to "/teams/" + @team.id.to_s
  end

  # POST /teams/add_member
  def add_member
    @team = (Team.find(params[:team_id])).id
    @new_member = (User.find(User.where("email = ?", params[:user_id]).ids.first)).id
    @member = Team.find(@team).members.create(user_id: @new_member)
    respond_to do |format|
      if @new_member.present?
        notice = t('.success')
        format.html { redirect_to "/teams/" + @team.to_s, notice: notice }
      else
        notice = t('.error')
        format.html { render :new, status: :unprocessable_entity, notice: notice }
      end
    end
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

  def create_everything
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

  def match_params
    params.require(:match).permit(:scheduled_at, :team_id, :place_id, :owner_id, :team_one_name, :team_two_name, :team_one_score, :team_two_score, :confirmed_at)
  end

  def place_params
    params.permit(:name, :address, :time, :day)
  end

  def user_id
    params.require(:user_id)
  end
end
