class Api::V2::HabitPlansController < ApplicationController

  def show_week
    week_habit_plans = HabitPlansFilterService.get_week_plans(params[:user_id])
    render json: week_habit_plans,
           include: [habit: {only: [:name, :description]}, habit_logs: {only: [:id, :habit_id, :scheduled_at, :completed_at]}], 
           status: :ok
  end

  def show_today
    today_habit_plans = HabitPlansFilterService.get_today_plans(params[:user_id])
    render json: today_habit_plans,
           include: [habit: {only: [:name, :description]}, habit_logs: {only: [:id, :habit_id, :scheduled_at, :completed_at]}], 
           status: :ok
  end

end
