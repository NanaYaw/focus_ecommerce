require 'rails_helper'

module Api
  module V1
    RSpec.describe UsersController, type: :request do
      let!(:user) { create(:user, role: 'admin') }
      let!(:logged_user) { :user }
      let!(:token) { generate_token(user) }
      let!(:product) { create(:product) }

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
          create_list(:user, 5)
          get '/api/v1/users', headers:
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns all users' do
          expect(json['data'][0].size).to eq(6)
        end
      end

      describe 'GET #show' do
        context 'when the user exists' do
          before { get "/api/v1/users/#{user.id}", headers: }

          it 'returns a success response' do
            expect(response).to have_http_status(:ok)
          end

          it 'returns the correct status message' do
            expect(json['status']['message']).to eq('users')
          end
        end

        context 'when the user does not exist' do
          before { get '/api/v1/users/0', headers: }

          it 'returns a not found response' do
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      describe 'Post #create' do
        let(:valid_attributes) do
          { name: 'new name', email: 'new@example.com', password: 'password' }
        end
        let(:invalid_attributes) { { name: '', email: 'invalid' } }

        context 'with valid parameters' do
          before do
            post('/api/v1/users/', params: { user: valid_attributes }, headers:)

            @user = json['data']
          end

          it 'updates the user' do
            expect(@user['name']).to eq('new name')
            expect(@user['email']).to eq('new@example.com')
          end

          it 'returns a success response' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'with invalid parameters' do
          before do
            post('/api/v1/users', params: { user: invalid_attributes }, headers:)
            @user = json
          end

          it 'returns an unprocessable entity response' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'returns error messages' do
            expect(@user['errors']).to be_present
          end
        end
      end

      describe 'PUT #update' do
        let(:valid_attributes) do
          { name: 'new name', email: 'new@example.com', password: 'password' }
        end
        let(:invalid_attributes) { { name: '', email: 'invalid' } }

        context 'with valid parameters' do
          before do
            patch("/api/v1/users/#{user.id}", params: { user: valid_attributes }, headers:)

            @user = json['data']
          end

          it 'updates the user' do
            expect(@user['name']).to eq('new name')
            expect(@user['email']).to eq('new@example.com')
          end

          it 'returns a success response' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'with invalid parameters' do
          before do
            patch("/api/v1/users/#{user.id}", params: { user: invalid_attributes }, headers:)
            @user = json
          end

          it 'returns an unprocessable entity response' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'returns error messages' do
            expect(@user['errors']).to be_present
          end
        end
      end

      describe 'DELETE #destroy' do
        context 'when the user exists' do
          it 'deletes the user and returns no content status' do
            initial_count = User.count

            delete("/api/v1/users/#{user.id}", headers:)

            expect(User.count).to eq(initial_count - 1)

            expect(response).to have_http_status(:no_content)
          end
        end

        context 'when the user does not exist' do
          it 'returns a not found status' do
            delete('/api/v1/users/0', headers:)
            expect(response).to have_http_status(:not_found)
            expect(response.parsed_body.dig(:errors, 0, :message)).to eq('Not Found')
          end
        end
      end
    end
  end
end
