module SetCurrent
  extend ActiveSupport::Concern

  def current_match
    @current_match = Match.where('scheduled_at >= ?', Time.now).first
    
  end

  def current_teams 
    @list_teams = Team.all
  end

  def list_match
    @list_match = Match.where('scheduled_at >= ?', Time.now).all
  end

end  