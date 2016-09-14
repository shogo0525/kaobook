class Topic < ActiveRecord::Base
	validates :content, presence: true

	#アソシエーション
	belongs_to :user
end
