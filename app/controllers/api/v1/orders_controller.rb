module Api
  module V1
    class OrdersController < ApplicationController
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
    end
  end
end
