class Album < ActiveRecord::Base
	has_many :slides, dependent: :restrict
end
