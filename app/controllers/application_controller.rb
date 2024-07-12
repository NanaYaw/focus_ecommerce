class ApplicationController < ActionController::API
  before_action :user_authorized

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  SECRET_KEY = Rails.application.credentials.to_s

  def not_found
    render json: {
      errors: [
        {
          status: '404',
          title: 'Not Found',
          message: 'Not Found'
        }
      ]
    }, status: :not_found
  end

  def record_invalid(message)
    default_message = {
      status: '400',
      title: '',
      message: 'Sorry something went wrong'
    }

    render json: {
      errors: [
        message.nil? ? default_message : message
      ]
    }, status: :bad_request
  end

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_user_token
    header = request.headers['Authorization']
    return unless header

    @token = header.split[1]
    begin
      JWT.decode(@token, SECRET_KEY, true, algorithm: 'HS256')
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
