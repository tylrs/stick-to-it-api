module Api
  module V2
    class InvitationsController < ApplicationController
      before_action :find_invite_info, only: [:create]

      def create
        invite_info = {
          recipient_name: mailer_params[:recipient_name],
          recipient_email: mailer_params[:recipient_email],
          habit_plan: @habit_plan,
          user: @user
        }
        invitation = @user.sent_invites.new(
          recipient_email: mailer_params[:recipient_email], 
          habit_plan_id: @habit_plan.id
        )
        if invitation.save
          HabitPlanInviterMailer.plan_invite_email(invite_info).deliver_later
          render json: { message: "Email Sent" }, status: :ok
        else
          render json: { errors: invitation.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def show_received
        user = User.find params[:user_id]
        invitations = Invitation.includes(:sender, habit_plan: [:habit]).where(recipient_email: user.email, status: "pending")
        if invitations.length.positive?
          render json: invitations, only: %i[id status habit_plan habit_plan_id sender recipient_email], 
                 include: [sender: { only: %i[name username] }, habit_plan: { only: %i[start_datetime end_datetime], include: [habit: { only: %i[name description] }] }], status: :ok
        else
          render json: { errors: "No invitations found" }, status: :not_found
        end
      end

      def show_sent
        sent_invites = Invitation.includes(:sender, habit_plan: [:habit]).where(sender_id: params[:user_id])
        if sent_invites.length.positive?
          render json: sent_invites, only: %i[id status habit_plan habit_plan_id sender recipient_email], 
                 include: [sender: { only: %i[name username] }, habit_plan: { only: %i[start_datetime end_datetime], include: [habit: { only: %i[name description] }] }], status: :ok
        else
          render json: { errors: "No sent invites found" }, status: :not_found
        end
      end

      def accept
        # look up invitation id 
        # if it's status is pending, then
          #
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
