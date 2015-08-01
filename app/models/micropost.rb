class Micropost < ActiveRecord::Base
  belongs_to :user
  #Stabby lambda! I like it :)
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true 
  validates	:content, presence: true, length: { maximum: 140 }
  validate 	:picture_size

  private
  
  	#Validates the size of an uploaded picture. 
  	def picture_size
  		if picture.size > 5.megabytes
  			errors.add(:picture, "Should be less than 5MB")
  		end 
  	end 
end
