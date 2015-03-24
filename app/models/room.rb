class Room < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: true

  scope :active, -> { where(active: true) }
end
