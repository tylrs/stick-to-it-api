class HabitsController < ApplicationController
  before_action :find_user

  def index
    habits = @user.habits.all
    render json: habits, status: :ok  
  end

  def create
    habit = @user.habits.create!(habit_params)
    if habit.valid?
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
        :name, :description, :start_datetime
      )
  end  
end
