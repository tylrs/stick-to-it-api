module Api
  module V2
    class InvitationsController < ApplicationController
      before_action :find_invite_info, only: [:create]
      before_action :find_invitation, only: [:accept]

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
        if @invitation.status == "pending"
          HabitPlansCreationService.create_partner_plans(@invitation.habit_plan_id, params[:user_id])
          @invitation.update(status: "accepted")
          render json: @invitation, status: :ok
        else
          render json: { errors: "Invitation has already been #{@invitation.status}" }, status: :unprocessable_entity
        end
      end
      
      private

      def find_invitation
        @invitation = Invitation.find params[:invitation_id]
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :not_found
      end

      def mailer_params
        params.permit(:user_id, :habit_plan_id, :recipient_name, :recipient_email)
      end

      def find_invite_info
        @habit_plan = HabitPlan.find params[:habit_plan_id]
        @user = User.find params[:user_id]
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :not_found
      end
    end
  end
end
