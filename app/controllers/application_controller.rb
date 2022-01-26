class ApplicationController < ActionController::API
    def hello
        render json: {
            message: "Hello World"
        }, status: 200
    end
end
