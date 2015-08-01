class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
	attr_accessor 	:remember_token, :activation_token, :reset_token
  	before_save   	:downcase_email
	before_create	:create_activation_digest
	validates :name, presence: true, length: {maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :email, format: { with: VALID_EMAIL_REGEX }, 
						presence: true, length: {maximum: 255},
						uniqueness: {case_sensitive: false}
	#has_secure_password automatically adds an authenticate method
	#witht the correct password it returns the user itself, false otherwise
	has_secure_password 
	validates :password, presence:true , length: { minimum: 6 }, allow_nil: true

	#returns the hash digest of the given string
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
													  BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end 

	def User.new_token
		SecureRandom.urlsafe_base64
	end 

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end 

	def authenticated?(attribute, token) 
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end 

	def forget
		update_attribute(:remember_digest, nil)
	end 

	#Activates an account
	def activate
		update_columns(activated: true, activated_at: Time.zone.now)
		#update_attribute(:activated, true)
		#update_attribute(:activated_at, Time.zone.now)
	end 

	#Sends activation email
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end 

	#Sets the password reset attribute
	def create_reset_digest
		self.reset_token = User.new_token
		update_columns(reset_digest: 	User.digest(reset_token),
					   reset_sent_at: 	Time.zone.now)
		#update_attribute(:reset_digest, User.digest(reset_token))
		#update_attribute(:reset_sent_at, Time.zone.now)
	end 

	#Sends password reset email
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end 

	#Returns true if password reset has expired.
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end 
	
	#Defines proto-feed
	def feed
	    Micropost.where("user_id = ?", id)
	end 

	private 
		#Converts email to all lower-case
		def downcase_email
      		self.email = email.downcase
		end 

		#Creates and assigns the activation token and digest
		def create_activation_digest
			self.activation_token  = User.new_token
      		self.activation_digest = User.digest(activation_token)
		end 
end
