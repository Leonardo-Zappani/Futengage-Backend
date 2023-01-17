class FutengagesController < ApplicationController

  include SetCurrent
  
  before_action :current_teams
  before_action :current_match
  before_action :list_match
  before_action :current_confirmation
  before_action :current_member
  before_action :current_player_count
  before_action :current_peding_confirmation

  # GET /futengages or /futengages.json
  def index
    

  end

  

  # GET /futengages/1 or /futengages/1.json
  def show
  end

  # GET /futengages/new
  def new
    @futengage = Futengage.new
  end

  # GET /futengages/1/edit
  def edit
  end

  # POST /futengages or /futengages.json
  def create
    @futengage = Futengage.new(futengage_params)

    respond_to do |format|
      if @futengage.save
        format.html { redirect_to futengage_url(@futengage), notice: "Futengage was successfully created." }
        format.json { render :show, status: :created, location: @futengage }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @futengage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /futengages/1 or /futengages/1.json
  def update
    respond_to do |format|
      if @futengage.update(futengage_params)
        format.html { redirect_to futengage_url(@futengage), notice: "Futengage was successfully updated." }
        format.json { render :show, status: :ok, location: @futengage }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @futengage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /futengages/1 or /futengages/1.json
  def destroy
    @futengage.destroy

    respond_to do |format|
      format.html { redirect_to futengages_url, notice: "Futengage was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def futengage_params
      params.require(:futengage).permit(:user_id,:name , :time, :day, :place, :scoreboard, :team_name_2, :team_name_1)
    end
end
