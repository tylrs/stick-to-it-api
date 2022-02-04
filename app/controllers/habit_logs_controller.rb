class HabitLogsController < ApplicationController
  def update
  end

  private

  def find_habit_log
    @habit_log = HabitLog.find_by id: params[:habit_log_id]
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end
end
