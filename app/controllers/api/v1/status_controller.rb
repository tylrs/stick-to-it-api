class Api::V1::StatusController < ApplicationController
  def current
    current_sha = GithubService.get_current_sha

    render json: {
      message: current_sha
    }, status: :ok
  end
end
