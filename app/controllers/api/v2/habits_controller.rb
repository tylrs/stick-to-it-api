class Api::V2::HabitsController < ApplicationController
  before_action :find_user, except: %i[index show_today]

  def index
    full_habits = HabitLogsFilterService.get_week_logs(params[:user_id])
    render json: full_habits, 
           include: [habit_logs: {only: [:id, :habit_id, :scheduled_at, :completed_at]}], 
           status: :ok  
  end

  def create
    created_habit = @user.created_habits.create(name: habit_params[:name], description: habit_params[:description])
    if created_habit.errors.count == 0
      habit_plan = @user.habit_plans.create(start_datetime: habit_params[:start_datetime], end_datetime: habit_params[:end_datetime], habit_id: created_habit.id)
      HabitLogsCreationService.create(habit_params, @user)
      render json: created_habit, status: :created
    else
      render json: { errors: created_habit.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def show
    habit = @user.habits.find_by id: params[:id]
    render json: habit, status: :ok
  end

  def show_today
    full_habits = HabitLogsFilterService.get_today_logs(params[:user_id])
    render json: full_habits, 
           include: [habit_logs: {only: [:id, :habit_id, :scheduled_at, :completed_at]}], 
           status: :ok  
  end

  def update
    habit = @user.habits.find_by id: params[:id]
    habit.update(habit_params)
    if habit.valid?
      render json: habit, status: :ok
    else 
      render json: { errors: habit.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @user.habits.destroy(params[:id])
  end

  private

  def find_user
    @user = User.find params[:user_id]
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "User not found" }, status: :not_found
  end

  def habit_params
      params.permit(
        :name, :description, :user_id, :start_datetime, :end_datetime
      )
  end  
end
