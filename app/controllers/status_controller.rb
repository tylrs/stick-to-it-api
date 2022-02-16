class StatusController < ApplicationController
  def current
    render json: {
      message: "Hello World"
    }, status: 200
  end
end