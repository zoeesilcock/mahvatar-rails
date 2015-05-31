class User < ActiveRecord::Base
  mount_uploader :head, HeadUploader

  def generate_token
    if !self.auth_token || self.auth_token_at < 5.days.ago
      self.auth_token = SecureRandom.urlsafe_base64
      self.auth_token_at = DateTime.now
      save
    end
  end

  def authenticate_token(token)
    if self.auth_token_at && self.auth_token_at < 5.days.ago
      self.auth_token = nil
      self.auth_token_at = nil
      save
    end

    return true if self.auth_token == token
  end
end
