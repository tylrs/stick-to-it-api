class HabitLogsController < ApplicationController
  before_action :find_habit_log

  def update
    if @habit_log.completed_at
      @habit_log.update(completed_at: nil)
      render json: { message: "Habit Marked Incomplete" }
    else
      @habit_log.update(completed_at: @habit_log.scheduled_at)
      render json: { message: "Habit Marked Complete" }
    end
  end

  private

  def find_habit_log
    @habit_log = HabitLog.find_by id: params[:id]
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Habit Log Not Found' }, status: :not_found
  end
end
