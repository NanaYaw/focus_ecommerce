require 'rails_helper'

module Api
  module V1
    RSpec.describe OrdersController, type: :request do
      let!(:user) { create(:user) }
      let!(:logged_user) { :user }
      let!(:token) { generate_token(user) }
      let!(:product) { create(:product) }
      let!(:order) { create(:order, user_id: user.id) }

      before do
        login(user.email, user.password)
      end

      let(:headers) { { 'Authorization' => "Bearer #{@token}" } }

      it 'logs in the user' do
        expect(@login_response).to have_http_status(:ok)
        expect(@token).not_to be_nil
      end

      describe 'POST #create' do
        let(:valid_attributes) do
          {
            orders: {
              user_id: user.id.to_s,
              product_lines: [
                {
                  quantity: 2,
                  product_id: product.id
                }
              ]
            }
          }
        end

        context 'with valid parameters' do
          it 'creates a new Order' do
            expect do
              post '/api/v1/orders', params: valid_attributes, headers:
            end.to change(Order, :count).by(1)
          end

          it 'creates a new Order' do
            expect do
              post '/api/v1/orders', params: valid_attributes, headers:
            end.to change(Order, :count).by(1)
          end

          it 'creates new ProductLines' do
            expect do
              post '/api/v1/orders', params: valid_attributes, headers:
            end.to change(ProductLine, :count).by(1)
          end

          it 'returns a created status' do
            expect(response).to have_http_status(:ok)
          end
        end
      end

      describe 'GET #user_orders' do
        before do
          get('/api/v1/orders/user_orders', headers:)
          @parsed_response = JSON.parse(response.body)
        end

        it 'has success http status' do
          expect(response).to have_http_status(:ok)
        end

        it 'has empty array when user has no order' do
          expect(@parsed_response['data']).to be_an(Array)
        end

        it 'has equal number of array of p' do
          expect(@parsed_response.size).to eq(1)
        end
      end
    end
  end
end
