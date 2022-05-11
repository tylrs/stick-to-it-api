module Api
  module V2
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: [:create]
      before_action :find_user_by_email, only: [:show]

      def show
        render json: @user.to_json(only: %i[name email]), status: :ok
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: user.to_json(only: %i[id name username email]), status: :created
        else
          render json: { errors: user.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        return if @user.update(user_params)

        render json: { errors: @user.errors.full_messages },
               status: :unprocessable_entity
      end

      private

      def find_user_by_email
        @user = User.find_by! email: params[:email]
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "User not found" }, status: :not_found
      end

      def user_params
        params.permit(
          :avatar, :name, :username, :email, :password, :password_confirmation
        )
      end
    end
  end
end
