class Album < ActiveRecord::Base
  scope :for_user, ->(user) { where("user_id = ?", user) }
	has_many :slides, dependent: :restrict_with_exception
  belongs_to :user
  
	validates :name, presence: true, uniqueness: true
end
