class HabitLogsController < ApplicationController
  before_action :find_habit_log

  def update
    log = HabitLogUpdateService.update(@habit_log)
    render json: {habit_log: log}, status: :ok
  end

  private

  def find_habit_log
    @habit_log = HabitLog.find id: params[:id]
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Habit Log Not Found" }, status: :not_found
  end
end
