module Api
  module V1
    class OrdersController < ApplicationController
      def create
        ActiveRecord::Base.transaction do
          order = current_user.orders.build(order_params.except(:product_lines))

          if order.save!
            order.product_lines.create!(order_params[:product_lines])
            binding.pry
            render json: [order, order.product_lines], status: :created
          else
            render json: order.errors, status: :unprocessable_entity
          end
        end
      end

      private

      def order_params
        params.require(:orders).permit(:user_id, product_lines: %i[quantity product_id])
      end
    end
  end
end
