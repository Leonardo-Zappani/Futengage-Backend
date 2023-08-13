# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :authenticate_user!

  # GET /matches
  def index
    @matches = current_user.next_matches

    render index: @matches, status: :ok
  end

  def all_matches
    @matches = current_user.matches.all

    render index: @matches, status: :ok
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

  # POST /matches or /matches.jso
  
  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    if @match.update(match_params)
      render :show, status: :ok, location: @match
    else
      render json: @match.errors, status: :unprocessable_entity
    end
  end

  # DELETE /matches/1 or /matches/1.json
  def destroy
    @match.destroy!

    render json: { message: 'Partida cancelada com sucesso!' }, status: :ok
  end

  private


  # Only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:scheduled_at, :team_id, :place_id, :owner_id, :team_one_name, :team_two_name, :team_one_score, :team_two_score, :confirmed_at)
  end
end
