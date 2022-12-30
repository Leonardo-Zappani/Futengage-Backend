# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[show destroy]

  # GET /categories or /categories.json
  def index
    query = Current.user.notifications

    @notifications_count = query.count
    @notifications = query.unread
  end

  def show
    @notification.mark_as_read
    redirect_to @notification.url
  end

  def dismiss_all
    respond_to do |format|
      if Current.user.notifications.mark_as_read!
        notice = t('.success')
        format.html { redirect_to notifications_url, notice: }
        format.json { render :show, status: :created, location: @notification }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  def mark_as_read
    respond_to do |format|
      if @notification.mark_as_read!
        notice = t('.success')
        format.html { redirect_to notifications_url, notice: }
        format.json { render :show, status: :created, location: @notification }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  def mark_as_unread
    respond_to do |format|
      if @notification.mark_as_read!
        notice = t('.success')
        format.html { redirect_to notifications_url, notice: }
        format.json { render :show, status: :created, location: @notification }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    @notification = Current.user.notifications.find(params[:id])
  end
end
