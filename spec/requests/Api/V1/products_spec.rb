require 'rails_helper'

module Api
  module V1
    RSpec.describe ProductsController, type: :request do
      let!(:user) { create(:user) }
      let!(:logged_user) { :user }
      let!(:token) { generate_token(user) }

      let!(:products) { create_list(:product, 10) }
      let!(:product_id) { products.first.id }
      let(:headers) { { 'Authorization' => "Bearer #{@token}" } }

      before do
        login(user.email, user.password)
      end

      it 'logs in the user' do
        expect(@login_response).to have_http_status(:ok)
        expect(@token).not_to be_nil
      end

      describe 'GET index' do
        before { get '/api/v1/products', headers: }

        it 'returns products' do
          expect(json['data']).not_to be_empty
        end

        it 'return the number of products created' do
          expect(json['data'].size).to eq(10)
        end
      end

      describe 'GET show' do
        before do
          get "/api/v1/products/#{product_id}",
              headers:
        end

        context 'when product record exists' do
          it 'returns the product' do
            expect(json['data']).not_to be_empty
          end

          it 'returns product ID' do
            expect(json['data']['id']).to eq(product_id)
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end

        context 'when product record does not exist' do
          let(:product_id) { 100 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end
        end
      end
    end
  end
end
