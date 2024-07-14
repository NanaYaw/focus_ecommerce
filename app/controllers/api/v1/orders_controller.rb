module Api
  module V1
    class OrdersController < ApplicationController
      before_action :set_order, only: %i[update show destroy]

      def index
        @orders = Order.all

        render json: {
          data: @orders
        }, status: :ok
      end

      def show
        render json: {
          data: @set_order
        }, status: :ok
      end

      def create
        ActiveRecord::Base.transaction do
          order = current_user.orders.build(order_params.except(:product_lines))

          if order.save
            if order_params[:product_lines].blank?
              render json: { errors: { product_lines: ["can't be blank"] } },
                     status: :unprocessable_entity
              raise ActiveRecord::Rollback
            end

            order.product_lines.create!(order_params[:product_lines])
            render json: [order, order.product_lines], status: :created
          else
            render json: { errors: order.errors }, status: :unprocessable_entity
          end
        end
      end

      def user_orders
        @user_orders = current_user.orders
        render json: { data: @user_orders }, status: :ok
      end

      private

      def order_params
        params.require(:orders).permit(:user_id, product_lines: %i[quantity product_id])
      end

      def set_order
        @set_order ||= Order.find(params['id'])
      end

      def error_updating(order)
        render json: { errors: order.errors },
               status: :unprocessable_entity
      end
    end
  end
end
