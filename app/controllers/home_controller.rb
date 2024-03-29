class HomeController < ApplicationController
  def index
    @next_match = current_user&.next_match
    @next_confirmation = current_user&.next_confirmation

    render json: { next_match: @next_match, next_confirmation: @next_confirmation } if current_user.present?
  end


  def today
    current_time = Time.now

    current_time.change(hour: 23, min: 59, sec: 59)
  end
end
