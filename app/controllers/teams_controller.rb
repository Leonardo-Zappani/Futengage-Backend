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

  # POST /teams/create_match 
  def create_match
    team = current_user.teams.find(params[:team_id])
    place = team.places.find(params[:place_id])
    @match = team.matches.new(scheduled_at: params[:scheduled_at], place: place, owner_id: params[:owner_id], team_one_name: params[:team_one_name], team_two_name: params[:team_two_name], team_one_score: params[:team_one_score], team_two_score: params[:team_two_score], confirmed_at: params[:confirmed_at])
      if @match.save
        render :show, status: :created, location: @match
      else
        render json: @match.errors, status: :unprocessable_entity
    end
  end

  # POST /teams/add_member
  def add_member
    team = current_user.teams.find(params[:team_id])
    new_member = User.find_by(email: params[:email])

    raise ActiveRecord::RecordNotFound unless new_member

    team.members.create(user_id: new_member)

    render json: { head: 'Membro adicionado com sucesso!' }
  end
  # POST /teams or /teams.json
  def create
    @team = current_user.owned_teams.create!(team_params)

    render show: @team, status: :created
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    if @team.update(team_params)
      render json: :show, status: :created, location: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy

    render json: { head: 'Time removido com sucesso!' }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # Only allow a list of trusted parameters through.
  def team_params
    params.permit(:group_name,:team_one_name, :team_two_name, :description)
  end

  def match_params
    params.require(:match).permit(:scheduled_at, :team_id, :place_id, :owner_id, :team_one_name, :team_two_name, :team_one_score, :team_two_score, :confirmed_at)
  end

  def place_params
    params.permit(:name, :address, :time, :day, :max_players)
  end

  def user_id
    params.require(:user_id)
  end
end
