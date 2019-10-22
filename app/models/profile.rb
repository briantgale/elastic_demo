class Profile < ApplicationRecord
  belongs_to :person

  validates :stuff, presence: true
end
