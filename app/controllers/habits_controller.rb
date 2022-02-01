class HabitsController < ApplicationController
  # before_action :authorize_request
  before_action :find_user

  def index  
  end

  def create
    @habit = @user.habits.create!(habit_params)
    if @habit.save
      render json: @habit, status: :created
    else
      render json: { errors: @habit.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def show
  end

  def update
  end

  def destroy
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
