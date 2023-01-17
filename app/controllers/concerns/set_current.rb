module SetCurrent
  extend ActiveSupport::Concern

  def current_teams 
    @list_teams = Team.joins(:members).where("members.user_id = ?", current_user.id).all
  end

  def current_match
    @current_match = current_user.teams.joins(:matches).where("matches.scheduled_at > ?", Time.now).order("matches.scheduled_at ASC").first.matches.where("matches.scheduled_at > ?", Time.now).order("matches.scheduled_at ASC").first
  end

  def current_member
    @current_member = @current_match.team.members.where(user_id: current_user.id)
  end

  def list_match
    @list_match = @all_matches
  end
  
  def current_confirmation
    @current_confirmation = Confirmation.joins(match: [team: :members]).where("members.user_id = ?", params[:user_id]).order("matches.scheduled_at ASC").first
  end

  def current_peding_confirmation
    @current_peding_confirmation = current_match.confirmations.first
  end

  def current_player_count
    @current_player_count = @current_match.confirmations.count
    @current_confirmed_player_count = @current_match.confirmations.where(confirmed: true).count
  end

end  