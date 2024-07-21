module Api
  module V1
    class OrdersController < ApplicationController
      before_action :set_order, only: %i[update show destroy]

      def index
        @orders = Order.includes(product_lines: :product).all

        render json: {
          data: ActiveModel::Serializer::CollectionSerializer.new(@orders,
                                                                  serializer: OrderSerializer)
        }, include: { product_lines: { include: :product } }, status: :ok
      end

      def show
        render json: {
          data: OrderSerializer.new(@set_order)
        }, status: :ok
      end

      def create
        ActiveRecord::Base.transaction do
          user_orders = current_user.orders.build(order_params.except(:product_lines))

          if user_orders.save
            if order_params[:product_lines].blank?
              render json: { errors: { product_lines: ["can't be blank"] } },
                     status: :unprocessable_entity
              raise ActiveRecord::Rollback
            end

            user_orders.product_lines.create!(order_params[:product_lines])
            render json: { data: OrderSerializer.new(user_orders) }, status: :created
          else
            render json: { errors: user_orders.errors }, status: :unprocessable_entity
          end
        end
      end

      def update
        order = current_user.orders.find(params[:id])

        ActiveRecord::Base.transaction do
          if order_updates_params[:product_lines].blank?
            render json: { errors: { product_lines: ["can't be blank"] } },
                   status: :unprocessable_entity
            raise ActiveRecord::Rollback
          end

          order_updates_params[:product_lines].each do |product_line_params|
            product_line = order.product_lines.find_or_initialize_by(id: product_line_params[:id])
            product_line.update!(product_line_params.except(:id))
          end

          if order.save
            render json: { data: OrderSerializer.new(order) },
                   status: :ok
          else
            render json: { errors: order.errors }, status: :unprocessable_entity
            raise ActiveRecord::Rollback
          end
        end
      end

      def user_orders
        @user_orders = current_user.orders_with_productlines_products
        render json: { data: @user_orders },
               status: :ok
      end

      def order_products
        @order = Order.find(params[:id])
        @products = @order.products
        render json: @products, status: :ok
      end

      def destroy
        order = Order.find(params[:id])
        order.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Order not found' }, status: :not_found
      end

      private

      def order_params
        params.require(:orders).permit(:user_id, product_lines: %i[quantity product_id])
      end

      def order_updates_params
        params.require(:orders).permit(:user_id, product_lines: %i[id quantity product_id])
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
