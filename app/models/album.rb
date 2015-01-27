class Album < ActiveRecord::Base
  # replaced by apartment gem:
  # scope :for_user, ->(user) { where("user_id = ?", user) }
  # belongs_to :user

	has_many :slides, dependent: :restrict_with_exception
	validates :name, presence: true, uniqueness: true
end
