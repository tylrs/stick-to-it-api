class ApplicationController < ActionController::API
  def hello
    render json: {
      message: "Hello World"
    }, status: 200
  end

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebTokenService.decode(header)
      @current_user = User.find(@decoded[:user_id])
      print "Begin statement worked"
    rescue ActiveRecord::RecordNotFound => e
      print "Active Record Error"
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      print "Decoding error"
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
