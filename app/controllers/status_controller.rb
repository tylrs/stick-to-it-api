class StatusController < ApplicationController
  def current
    current_sha = GithubService.get_current_sha

    render json: {
      message: current_sha
    }, status: 200
  end
end