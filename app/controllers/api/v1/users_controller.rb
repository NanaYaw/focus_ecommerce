module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :user_authorized, only: [:create]
      before_action :user, only: %i[update show destroy]

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

      def create
        @user = User.new(user_params)
        if @user.save
          render json: { data: @user,
                         status: { code: 200,
                                   message: "User #{@user.name}  created successfully" } },
                 status: :ok
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
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
        user = User.find(params[:id])
        user.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
      end

      private

      def user
        @user ||= User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end

      def error_updating
        render json: { errors: 'unprocessable_entity', status: :unprocessable_entity },
               status: :unprocessable_entity
      end
    end
  end
end
