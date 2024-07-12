module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :user_authorized, only: [:login]
      rescue_from ActiveRecord::RecordNotFound, with: :handle_user_record_not_found

      def login
        user = User.find_by!(email: login_params[:email])
        if user.authenticate(login_params[:password])
          @token = encode_token(user_id: user.id)
          render json: {
            user:,
            token: @token
          }, status: :ok
        else
          render json: { message: 'Incorrect password' }, status: :unauthorized
        end
      end

      def destroy
        session[:user_id] = nil
        if current_user
          render json: {
            status: 200,
            message: 'logged out successfully'
          }, status: :ok
        else
          render json: {
            status: 401,
            message: "Couldn't find an active session."
          }, status: :unauthorized
        end
      end

      private

      def login_params
        params.permit(:email, :password)
      end

      def handle_user_record_not_found(_e)
        render json: { message: 'Please check email | password and try again' },
               status: :unauthorized
      end

      def jwt_decode(token)
        decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS512' })[0]
        result = ActiveSupport::HashWithIndifferentAccess.new decoded
        return nil if Time.zone.at(result[:exp]) < Time.zone.now

        result
      end
    end
  end
end
