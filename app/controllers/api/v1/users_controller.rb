module Api
  module V1
    class UsersController < ApplicationController
      before_action :user, only: %i[edit update show destroy]
      def index
        @users = User.all

        render json: {
          status: { code: 200, message: 'users' },
          data: @users
        }, status: :ok
      end

      def show
        render json: {
          status: { code: 200, message: 'users' },
          data: @user
        }, status: :ok
      end

      def edit
      end

      def update
        if @user.update(user_params)
          render json: { data: @user,
                         status: { code: 200, message: 'User updated successfully' } },
                 status: :ok
        else
          error_updating
        end
      end

      def destroy
      end

      private

      def user
        @user ||= User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email)
      end

      def error_updating
        render json: { errors: 'unprocessable_entity', status: :unprocessable_entity },
               status: :unprocessable_entity
      end
    end
  end
end
