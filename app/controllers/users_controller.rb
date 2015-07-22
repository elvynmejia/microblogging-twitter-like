class UsersController < ApplicationController
	#for creating new users
  #controller convention of plural resource name
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  	#debugger
  end 

  def create
	@user = User.new(user_params)
  	if @user.save
      log_in @user
  		#handle a successful save
  		#render the profile
      #not entirely sure how this renders the new created user profile
      #there is no view that corresponds to the newly created user profile
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
  	else
  		#handle a failure save
  		render 'new'
  	end 
  end 

  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password, 
  									 :password_confirmation)
  	end 
end
