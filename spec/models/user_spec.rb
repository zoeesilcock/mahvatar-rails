require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user}

  describe 'generate_token' do

    context 'user has no token' do
      it 'populates the auth_token field with a random value' do
        expect{user.generate_token}.to change{user.auth_token}
      end

      it 'sets the auth_token_at field to the current date' do
        expect{user.generate_token}.to change{user.auth_token_at}
      end
    end

    context 'user has a valid token' do
      before do
        user.generate_token
      end

      it 'populates the auth_token field with a random value' do
        expect{user.generate_token}.to_not change{user.auth_token}
      end

      it 'sets the auth_token_at field to the current date' do
        expect{user.generate_token}.to_not change{user.auth_token_at}
      end
    end

    context 'user has an expired token' do
      before do
        user.generate_token
        user.auth_token_at = 6.days.ago
      end

      it 'populates the auth_token field with a random value' do
        expect{user.generate_token}.to change{user.auth_token}
      end

      it 'sets the auth_token_at field to the current date' do
        expect{user.generate_token}.to change{user.auth_token_at}
      end
    end
  end

  describe 'authenticate_token' do
    let(:token) { "my_super_sweet_token" }

    context 'token matches' do
      before do
        user.auth_token = token
        user.auth_token_at = 5.minutes.ago
      end

      it 'returns true' do
        expect(user.authenticate_token(token)).to be_truthy
      end
    end

    context 'token does not match' do
      it 'returns false' do
        expect(user.authenticate_token("poop")).to be_falsy
      end
    end

    context 'token has expired' do
      before do
        user.auth_token = token
        user.auth_token_at = 6.days.ago
      end

      it 'returns false' do
        expect(user.authenticate_token(token)).to be_falsy
      end

      it 'removes the auth_token value' do
        user.authenticate_token(token)
        expect(user.auth_token).to be_nil
      end

      it 'removes the auth_token_at date' do
        user.authenticate_token(token)
        expect(user.auth_token).to be_nil
      end
    end
  end
end
