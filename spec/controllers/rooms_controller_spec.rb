require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe 'GET #index' do
    it 'repsonds with 200 success' do
      get :index

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET #show' do
    it 'repsonds with 200 success' do
      get :show, id: 1

      expect(response).to have_http_status :ok
    end
  end
end
