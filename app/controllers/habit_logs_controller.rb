class HabitLogsController < ApplicationController
  before_action :find_habit

  def index
    habit_logs = @habit.habit_logs.all
    render json: habit_logs, status: :ok  
  end

  def update
  end

  private

  def find_habit 
    @habit = Habit.find_by id: params[:habit_id]
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Habit not found' }, status: :not_found
  end

  def find_habit_log
    @habit_log = HabitLog.find_by id: params[:habit_log_id]
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Habit Log Not Found' }, status: :not_found
  end
end
