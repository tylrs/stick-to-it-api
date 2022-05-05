module Api
  module V2
    class InvitationController < ApplicationController
      before_action :find_user, :find_habit_plan

      def create
        HabitPlanInviterMailer.plan_invite_email(@user, @habit_plan, { name: recipient_params[:name], email: recipient_params[:email] }).deliver_later

        render json: { message: "Email Sent" }, status: :ok
      end
    
      private
    
      def recipient_params
        params.permit(:name, :email)
      end
    
      def find_habit_plan
        @habit_plan = HabitPlan.find params[:habit_plan_id]
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "Habit Plan not found" }, status: :not_found
      end
    
      def find_user
        @user = User.find params[:user_id]
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "User not found" }, status: :not_found
      end
    
    end
  end
end
