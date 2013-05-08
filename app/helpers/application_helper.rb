module ApplicationHelper

	#returns the full title
	def full_title(page_title)
		base_title = "Cognitive Rehabilitation Therapy"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
end
