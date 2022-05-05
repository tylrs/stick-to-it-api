class InvitationController < ApplicationController
  def create
    #before action find user, habit plan
    
    #need user, habit_plan, and recipient_info
    #strong params for recipient info
    HabitPlanInviterMailer.plan_invite_email
  end

  private

  def recipient_params
    params.permit(:name, :email)
  end

  def find_habit_plan
    @habit_plan = HabitPlan.find params[:habit_plan_id
  rescue ActiveRecord::RecordNotFound
    render json: {errors: "Habit Plan not found"}, status: :not_found
  end

  def find_user
    @user = User.find params[:user_id]
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "User not found" }, status: :not_found
  end

end
