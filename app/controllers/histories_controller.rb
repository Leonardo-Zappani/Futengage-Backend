# frozen_string_literal: true

class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @histories = current_user.past_matches

    render index: @histories, status: :ok
  end

  private

  def history_params
    params.fetch(:history, {})
  end
end
