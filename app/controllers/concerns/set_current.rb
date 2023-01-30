module SetCurrent
  extend ActiveSupport::Concern

  def current_teams 
    if @current_match.present?
      @list_teams = Team.joins(:members).where("members.user_id = ?", current_user.id).all
      return @list_teams
    end
  end

  def current_team
    if @current_match.present?
      @current_team = @current_match.team
      return @current_team
    end
  end

  def current_match
    if current_user.teams.present? && current_user.teams.joins(:matches).any?
      @current_match = current_user.matches.where("scheduled_at > ?", Time.now-1.day).order("scheduled_at ASC").first
    end
  end

  def all_matches
    if current_user.teams.present? && current_user.teams.joins(:matches).any?
      @all_matches = current_user.matches.all
    end
  end

  def past_matches
    if current_user.teams.present? && current_user.teams.joins(:matches).any?
      @past_matches = current_user.matches.where("scheduled_at < ?", Time.now-1.day).order("scheduled_at ASC")
    end
  end


  def current_member
    if @current_match.present?
      @current_member = @current_match.team.members.find_by(user_id: current_user.id)
    else
      nil
    end
  end

  def list_match
    if @current_match.present?
      @all_matches = @current_match.team.matches
      return @all_matches
    end
  end

  def current_confirmation
    if @current_match.present?  
      @current_confirmation = @current_match.confirmations.find_by(member_id: current_member)
      return @current_confirmation
    end
  end

  def current_peding_confirmation
    if @current_match.present?
      @current_peding_confirmation = @current_match.confirmations.find_by(member_id: current_member)
      return @current_peding_confirmation
    end
  end

  def current_player_count
    if @current_match.present?
      @current_player_count = @current_match.team.members.count
      @current_confirmed_count = @current_match.confirmations.where("confirmed = ?", true).count
    end
  end
end