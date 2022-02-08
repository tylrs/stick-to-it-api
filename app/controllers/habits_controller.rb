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
      date1 = Date.parse(habit_params[:start_datetime])
      date2 = Date.parse(habit_params[:end_datetime])
      num_logs = (date2 - date1).numerator
      num_logs += 1
      habit = @user.habits.order("created_at").last
      current_date = date1
      num_logs.times {
        log = habit.habit_logs.build(scheduled_at: "#{current_date}")
        habit.habit_logs << log
        current_date += 1.day       
      }
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
