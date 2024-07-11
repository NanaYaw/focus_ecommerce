class ApplicationController < ActionController::API
  before_action :user_authorized

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

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
end
