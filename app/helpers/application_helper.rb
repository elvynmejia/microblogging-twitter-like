module ApplicationHelper
	#if no page tittle is defined returnt the base title
	#else return the page_title | base_title
	def full_title page_title= ''
		base_title= "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_title
		else 
			"#{page_title} | #{base_title}"
		end 
	end 
end
