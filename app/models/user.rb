class User < ActiveRecord::Base
	#add validation on email and password
	before_save { email.downcase! }
	validates :name, presence: true, length: {maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :email, format: { with: VALID_EMAIL_REGEX }, 
						presence: true, length: {maximum: 255},
						uniqueness: {case_sensitive: false}
	#has_secure_password automatically adds an authenticate method
	#witht the correct password it returns the user itself, false otherwise
	has_secure_password 
	validates :password, length: {minimum: 6}

end
