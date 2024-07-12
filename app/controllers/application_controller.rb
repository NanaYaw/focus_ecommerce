class ApplicationController < ActionController::API
  before_action :user_authorized

  include ExceptionHandler

  SECRET_KEY = Rails.application.credentials.secret_key_base

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY, 'HS512')
  end

  def decode_user_token
    header = request.headers['Authorization']
    return unless header

    @token = header.split[1]

    begin
      JWT.decode(@token, SECRET_KEY, true, { algorithm: 'HS512' })
    rescue JWT::DecodeError
      nil
    end
  end

  def current_user
    return if decode_user_token.nil?

    user_id = decode_user_token[0]['user_id']
    User.find_by(id: user_id)
  end

  def user_authorized
    return unless current_user.nil?

    render json: { message: 'Please log in' }, status: :unprocessable_entity
  end
end
