class Album < ActiveRecord::Base
	has_many :slides, dependent: :restrict_with_exception
	validates :name, presence: true, uniqueness: true
end
