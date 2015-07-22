require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	test 'invalid signup information' do 
		get signup_path
		assert_no_difference 'User.count' do 
			post users_path, user: { name: "",
									 email: "user@invalid",
									 password: "foo",
									 password_confirmation: "bar" }
		end
		assert_template 'users/new'
		assert_select 'div#<CSS id for error explanation>'
		assert_select 'div.<CSS class for field with error>'
	end 

	test 'valid signup information' do 
		get signup_path
		assert_difference 'User.count', 1 do
			#post to the users path
			post_via_redirect users_path, user: { name: "Example User",
												  email: "user@example.com",
												  password: "foobar", 
												  password_confirmation: "foobar"} 
		end 
		#redirect after submission
	assert_template 'users/show'
	assert_not flash.nil?
	assert is_logged_in? #assert that the user is logged in after signing up
	end 


end
