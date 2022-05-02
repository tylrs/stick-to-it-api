module Api
  module V2
    class StatusController < ApplicationController
      def current
        current_sha = GithubService.get_current_sha

        render json: {
          message: current_sha
        }, status: :ok
      end
    end
  end
end
