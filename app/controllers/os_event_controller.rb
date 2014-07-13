require 'open-uri'

class OsEventController < ApplicationController

	def event
		render :json => open("http://connpass.com/api/v1/event/?count=5").read
	end

end
