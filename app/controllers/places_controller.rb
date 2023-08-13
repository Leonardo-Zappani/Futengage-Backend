# frozen_string_literal: true

class PlacesController < ApplicationController
  before_action :authenticate_user!

  # GET /places
  def index
    @places = current_user.teams.map { |team| team.places }.flatten
  end

  # GET /places/1 or /places/1.json
  def show
  end

  # POST /places or /places.json
  def create
    team = current_user.teams.find(params[:team_id])

    raise ActiveRecord::RecordNotFound unless team

    @place = team.places.create(place_params)

    render show: @place, status: :created
  end

  # PATCH/PUT /places/1 or /places/1.json
  def update
    if @place.update(place_params)
      render :show, status: :ok, location: @place
    else
      ender json: @place.errors, status: :unprocessable_entity
    end
  end

  # DELETE /places/1 or /places/1.json
  def destroy
    @place.destroy

    render json: { message: 'Local removido com sucesso' }, status: :ok
  end

  private

  # Only allow a list of trusted parameters through.
  def place_params
    params.fetch(:place, {})
  end
end
