class HomeController < ApplicationController
  def index
    @next_match = current_user.unconfirmed_matches&.order(scheduled_at: :asc)&.first
    @next_confirmation = current_user.unconfirmed_matches&.where(active: true).order(scheduled_at: :asc)&.first

    render json: { next_match: @next_match, next_confirmation: @next_confirmation }
  end


  def today
    current_time = Time.now

    current_time.change(hour: 23, min: 59, sec: 59)
  end
end
