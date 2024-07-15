module Api
  module V1
    class ProductsController < ApplicationController
      before_action :product, only: %i[show destroy]

      def index
        @products = Product.all
        render json: {
          status: { code: 200, message: 'List of products' },
          data: @products
        }, status: :ok
      end

      def show
        render json: {
          status: { code: 200, message: 'products' },
          data: @product
        }, status: :ok
      end

      def destroy
        @product.destroy
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
