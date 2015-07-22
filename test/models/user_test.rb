require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  #automatically gets run before each test
  def setup 
  	@user = User.new(name: "Example User", email: "user@example.com", 
  						password: "foobar", password_confirmation: "foobar")
  end 

  test 'should be valid' do 
  	assert @user.valid?
  end 

  test 'name should be present' do 
  	@user.name = "	"
  	assert_not @user.valid? 
  end 

  test 'email should be present' do 
  	@user.email = " "
  	assert_not @user.valid?
  end 

  test 'name should not be too long' do 
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end 

  test 'email should not be too long' do 
  	@user.email = "a" * 244 + "@example.com"
  	assert_not @user.valid?
  end 

  test 'email validation should accept valid addresses' do 
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_addr|
    	@user.email = valid_addr
    	assert @user.valid?, "#{valid_addr.inspect} should be valid"
    end 
  end 

  test 'email validation should reject invalid addresses' do 
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_addr|
    	@user.email = invalid_addr
    	assert_not @user.valid?, "#{invalid_addr.inspect} should be invalid"
    end 
  end 

  test 'email address should be unique' do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end 

  test 'email addresses should be saved as lower-case ' do 
  	mixed_case_email = "Foo@ExaMPle.CoM"
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal mixed_case_email.downcase, @user.reload.email
  end  

  test 'password should have a minimum lenght' do 
  	@user.password = @user.password_confirmation = "a" * 5
  	assert_not @user.valid?
  end 

  test 'authenticated? should return false for a user with nil digest' do 
    assert_not @user.authenticated?('')
  end 
end
