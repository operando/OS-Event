require 'open-uri'
require 'json'
require 'hashie/mash'

class OsEventController < ApplicationController

	def event
		connpass_json_str = open("http://connpass.com/api/v1/event/?nickname=operandoOS").read
		
		event_array = Array.new

		connpass_event_mash = Hashie::Mash.new(JSON.parse(connpass_json_str))

		connpass_event_mash.events.each { |e|
			connpass_event = Event.new 
			
			connpass_event.title = e.title
			connpass_event.url = e.event_url
			connpass_event.address = e.address		
			connpass_event.description = e.description
			connpass_event.start_time = e.started_at
			connpass_event.end_time = e.ended_at
			connpass_event.event_site = "connpass"

			event_array.push(connpass_event)
		}

		render :json => event_array
	end

end
