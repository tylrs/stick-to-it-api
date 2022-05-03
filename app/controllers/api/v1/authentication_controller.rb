module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authorize_request, except: :login

      def login
        user = User.find_by_email(login_params[:email])

        if user&.authenticate(login_params[:password])
          token = JsonWebTokenService.encode(user_id: user.id)
          expiration_time = (Time.now + 24.hours.to_i).strftime("%m-%d-%Y %H:%M")
          user_payload = { 
            id: user.id, 
            name: user.name, 
            username: user.username, 
            email: user.email 
          }

          render json: { 
            token: token, 
            exp: expiration_time,          
            user: user_payload
          }, status: :ok
        else
          render json: { error: "unauthorized" }, status: :unauthorized
        end
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
