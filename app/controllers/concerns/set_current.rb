module SetCurrent
  extend ActiveSupport::Concern

  def current_match
    @all_matches = Match.where('scheduled_at >= ?', Time.now).first.team.members.where(id: current_user.id).all
    @current_match = @all_matches.first
  end

  def current_member
    @current_member = @current_match.team.members.where(user_id: current_user.id)
  end

  def current_teams 
    @list_teams = Member.where(user_id: current_user.id)
  end

  def list_match
    @list_match = @all_matches
  end

  def current_peding_confirmation
    @current_peding_confirmation = Confirmation.where(member_id: @current_member.ids).first
  end

  def current_player_count
    @current_player_count = @current_match.confirmations.count
    @current_confirmed_player_count = @current_match.confirmations.where(confirmed: true).count
  end

end  