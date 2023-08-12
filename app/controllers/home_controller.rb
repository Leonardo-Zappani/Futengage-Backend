class HomeController < ApplicationController
  def index
    next_match = current_user.unconfirmed_matches.where("scheduled_at < ?", today).order(scheduled_at: :asc).first
    next_confirmation = current_user.pending_confirmations.where()
  end


  def today
    current_time = Time.now

    current_time.change(hour: 23, min: 59, sec: 59)
  end
end
