module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: %i[show update destroy]

      def index
        products = Product.all
        render json: {
          status: { code: 200, message: 'List of products' },
          data: products
        }, status: :ok
      end

      def show
        render json: {
          status: { code: 200, message: 'products' },
          data: @set_product
        }, status: :ok
      end

      def create
        if current_user.nil? || !current_user.role_admin?
          return render json: { data: current_user, error: 'Permission denied, you must be an admin to create a product' },
                        success: false
        end

        product = Product.new(product_params)

        if product.save
          render json: { data: product,
                         status: { code: 200,
                                   message: "Product #{product.name}  created successfully" } },
                 status: :ok
        else
          render json: { errors: product.errors }, status: :unprocessable_entity
        end
      end

      def update
        if current_user.nil? || !current_user.role_admin?
          return render json: { data: current_user, error: 'Permission denied, you must be an admin to update a product' },
                        success: false
        end

        if @set_product.update(product_params)
          render json: { data: @set_product,
                         status: { code: 200, message: 'User updated successfully' } },
                 status: :ok
        else
          render json: { errors: @set_product.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if current_user.nil? || !current_user.role_admin?
          return render json: { data: current_user, error: 'Permission denied, you must be an admin to destroy a product' },
                        success: false
        end

        @set_product.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product not found' }, status: :not_found
      end

      def low_stock
        low_stock_products = Product.low_stock
        render json: {
          status: { code: 200, message: 'Low stock products' },
          data: low_stock_products
        }, status: :ok
      end

      private

      def set_product
        @set_product ||= Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :stock, :price)
      end
    end
  end
end
