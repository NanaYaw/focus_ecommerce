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
        if @set_product.update(product_params)
          render json: { data: @set_product,
                         status: { code: 200, message: 'User updated successfully' } },
                 status: :ok
        else
          render json: { errors: @set_product.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @set_product.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product not found' }, status: :not_found
      end

      private

      def product
        @product ||= Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :stock, :price)
      end
    end
  end
end
