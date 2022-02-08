class HabitsController < ApplicationController
  before_action :find_user

  def index
    habits = @user.habits.all
    full_habits = habits.map do |habit|
      full_habit = {habitInfo: habit}
      full_habit[:logs] = HabitLogsWeeklyService.get_logs(habit.id)
      full_habit
    end
    render json: full_habits, status: :ok  
  end

  def create
    habit = @user.habits.build(name: habit_params[:name], description: habit_params[:description])
    if @user.habits << habit
      HabitCreationService.create(habit_params, habit, @user)
      render json: habit, status: :created
    else
      render json: { errors: habit.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def show
    habit = @user.habits.find_by id: params[:id]
    render json: habit, status: :ok
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
    @user = User.find_by id: params[:user_id]
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  def habit_params
      params.permit(
        :name, :description, :user_id, :start_datetime, :end_datetime
      )
  end  
end
