require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe 'GET #index' do
    it 'responds with 200 success' do
      get :index

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET #show' do
    let(:room) { create :room }

    it 'responds with 200 success' do
      get :show, id: room

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET #new' do
    it 'responds with 200 success' do
      get :new

      expect(response).to have_http_status :ok
    end
  end

  describe 'POST #create' do
    context 'with a valid room' do
      let(:create_room) { post :create, room: attributes_for(:room) }

      it 'redirects to the room list' do
        create_room

        expect(response).to redirect_to :rooms
      end

      it 'creates a new room' do
        expect{create_room}.to change{Room.count}.from(0).to(1)
      end
    end

    context 'with an invalid room' do
      it 'shows the new form' do
        post :create, room: { title: nil }

        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    let(:room) { create :room }

    it 'responds with 200 success' do
      get :edit, id: room

      expect(response).to have_http_status :ok
    end
  end

  describe 'PUT #update' do
    let(:room) { create :room }
    let(:new_title) { 'Super awesome mega room' }

    context 'with a valid room' do
      before do
        put :update, id: room, room: { title: new_title }
      end

      it 'redirects the user' do
        expect(response).to redirect_to :rooms
      end

      it 'updates the room' do
        expect(room.reload.title).to eq new_title
      end
    end

    context 'with an invalid room' do
      it 'shows the edit form' do
        put :edit, id: room, room: { title: nil }

        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:room) { create :room }
    let(:delete_room) { delete :destroy, id: room }

    it 'removed the room' do
      expect{delete_room}.to change{Room.count}.from(1).to(0)
    end

    it 'redirects to room list' do
      delete_room

      expect(response).to redirect_to :rooms
    end
  end

  describe 'PUT #start' do
    let!(:room) { create :room }

    it 'redirects back to edit' do
      put :start, room_id: room

      expect(response).to redirect_to edit_room_path(room)
    end
  end
end
