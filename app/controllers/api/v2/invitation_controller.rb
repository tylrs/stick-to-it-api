module Api
  module V2
    class InvitationController < ApplicationController
      before_action :find_invite_info

      def create
        invite_info = {
          recipient_name: mailer_params[:recipient_name],
          recipient_email: mailer_params[:recipient_email],
          habit_plan: @habit_plan,
          user: @user
        }

        HabitPlanInviterMailer.plan_invite_email(invite_info).deliver_later

        render json: { message: "Email Sent" }, status: :ok
      end

      private

      def mailer_params
        params.permit(:user_id, :habit_plan_id, :recipient_name, :recipient_email)
      end

      def find_invite_info
        @habit_plan = HabitPlan.find params[:habit_plan_id]
        @user = User.find params[:user_id]
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "Record not found" }, status: :not_found
      end
    end
  end
end
