require 'rails_helper'

module Api
  module V1
    RSpec.describe OrdersController, type: :request do
      let!(:user) { create(:user) }
      let!(:logged_user) { :user }
      let!(:token) { generate_token(user) }
      let!(:product) { create(:product) }
      let!(:order) { create(:order, user:) }

      before do
        login(user.email, user.password)
      end

      let(:headers) { { 'Authorization' => "Bearer #{@token}" } }

      it 'logs in the user' do
        expect(@login_response).to have_http_status(:ok)
        expect(@token).not_to be_nil
      end

      describe 'GET index' do
        before do
          create_list(:order, 5)
          get '/api/v1/orders', headers:
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns all orders' do
          expect(json['data'].size).to eq(6)
        end
      end

      describe 'GET #show' do
        context 'when the order exists' do
          before { get "/api/v1/orders/#{order.id}", headers: }

          it 'returns a success response' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when the order does not exist' do
          before { get '/api/v1/order/0', headers: }

          it 'returns a not found response' do
            expect(response).to have_http_status(:not_found)
          end
        end
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

        before do
          create(:product_line, product_id: product.id, order_id: order.id)
        end

        context 'with valid parameters' do
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

      describe 'POST #update' do
        before do
          patch("/api/v1/orders/#{order.id}", params: {
                  orders: {
                    user_id: user.id.to_s,
                    product_lines: [
                      {
                        quantity: 2,
                        product_id: product.id
                      }
                    ]
                  }
                }, headers:)

          @product_response = response
          @product_lines = json['data']['product_lines']
          @product_id = json['data']['id']
        end

        let!(:product_line) { create(:product_line) }

        let(:valid_attributes) do
          {
            orders: {
              user_id: user.id.to_s,
              product_lines: [
                {
                  quantity: 2,
                  product_id: product.id,
                  id: product_line.id
                }
              ]
            }
          }
        end

        context 'with valid parameters' do
          it 'returns an ok status' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the product line quantity' do
            expect(@product_lines.first['quantity']).to eq(2)
          end

          it 'returns the updated order' do
            expect(@product_id).to eq(order.id)
          end

          it 'returns a created status' do
            expect(response).to have_http_status(:ok)
          end
        end
      end

      describe 'GET #user_orders' do
        before do
          get('/api/v1/orders/user_orders', headers:)
        end

        it 'has success http status' do
          expect(response).to have_http_status(:ok)
        end

        it 'has empty array when user has no order' do
          expect(json['data']).to be_an(Array)
        end

        it 'has equal number of array of p' do
          expect(json.size).to eq(1)
        end
      end

      describe 'DELETE #destroy' do
        context 'when the order exists' do
          before do
            create(:order, user:)
          end

          it 'deletes the order and returns no content status' do
            initial_count = Order.count

            delete("/api/v1/orders/#{order.id}", headers:)

            expect(Order.count).to eq(initial_count - 1)

            expect(response).to have_http_status(:no_content)
          end
        end

        context 'when the order does not exist' do
          it 'returns a not found status' do
            delete('/api/v1/orders/0', headers:)
            expect(response).to have_http_status(:not_found)
            expect(response.parsed_body.dig(:errors, 0, :message)).to eq('Not Found')
          end
        end
      end
    end
  end
end
