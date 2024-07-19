module Api
  module V1
    class UsersController < ApplicationController
      before_action :user, only: %i[update show destroy]

      def index
        @users = User.all

        render json: {
          status: { code: 200, message: 'users' },
          data: [ActiveModel::Serializer::CollectionSerializer.new(@users,
                                                                   serializer: UserSerializer)]
        }, status: :ok
      end

      def show
        render json: {
          status: { code: 200, message: 'users' },
          data: UserSerializer.new(@user)
        }, status: :ok
      end

      def create
        if current_user.nil? || !current_user.role_admin?
          return render json: { error: 'Permission denied, you must be an admin to create a user' },
                        success: false
        end

        @user = User.new(user_params)
        if @user.save
          render json: { data: UserSerializer.new(@user),
                         status: { code: 200,
                                   message: "User #{@user.name}  created successfully" } },
                 status: :ok
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: { data: UserSerializer.new(@user),
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
        params.require(:user).permit(:role, :name, :email, :password)
      end

      def error_updating
        render json: { errors: 'unprocessable_entity', status: :unprocessable_entity },
               status: :unprocessable_entity
      end
    end
  end
end
