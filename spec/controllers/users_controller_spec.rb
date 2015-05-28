require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create :user }

  describe 'GET #edit' do
    context 'with valid token' do
      before do
        user.generate_token
      end

      it 'returns http success' do
        get :edit, id: user.id, auth_token: user.auth_token
        expect(response).to have_http_status(:success)
      end
    end

    context 'without valid token' do
      it 'returns 401 unauthorized' do
        get :edit, id: user.id, auth_token: 'clearly_not_awesome_token'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    let(:new_name) { 'Prostetnic Vogon Jeltz' }

    context 'with valid token' do
      before do
        user.generate_token
      end

      it 'returns http success' do
        put :update, id: user.id, auth_token: user.auth_token, user: { name: new_name }
        expect(response).to have_http_status(:success)
      end

      it 'updates the user' do
        put :update, id: user.id, auth_token: user.auth_token, user: { name: new_name }
        expect(user.reload.name).to eq(new_name)
      end
    end

    context 'without valid token' do
      it 'returns 401 unauthorized' do
        put :update, id: user.id, user: { name: new_name }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not update the user' do
        put :update, id: user.id, user: { name: new_name }
        expect(user.reload.name).to_not eq(new_name)
      end
    end
  end
end
