require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
#Integration test to test links of layout page
=begin
	1. Get the root path 
	2. Verify that the right page template is rendered
	3. Check the correct links for Home, Help, About, Contact
=end 
	test 'layout links' do 
		get root_path
		assert_template 'static_pages/home'
		assert_select "a[href=?]", root_path, count: 2 #test for the presence of a particular URL
		assert_select "a[href=?]", help_path
		assert_select "a[href=?]", contact_path
		assert_select "a[href=?]", about_path

		get signup_path
		assert_select "title", full_title("Sign up")
	end  

end
