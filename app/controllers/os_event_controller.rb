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

		zusaar_mash = Hashie::Mash.new(JSON.parse(open("http://www.zusaar.com/api/event/user/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww").read))

		zusaar_mash.event.each { |e|
			zusaar_event = Event.new 
			
			zusaar_event.title = e.title
			zusaar_event.url = e.event_url
			zusaar_event.address = e.address		
			zusaar_event.description = e.description
			zusaar_event.start_time = e.started_at
			zusaar_event.end_time = e.ended_at
			zusaar_event.event_site = "zusaar"

			event_array.push(zusaar_event)
		}

		atnd_mash = Hashie::Mash.new(JSON.parse(open("http://api.atnd.org/events/?nickname=operando&format=json").read))

		atnd_mash.events.each { |e|
			atnd_event = Event.new 
			
			atnd_event.title = e.title
			atnd_event.url = e.event_url
			atnd_event.address = e.address		
			atnd_event.description = e.description
			atnd_event.start_time = e.started_at
			atnd_event.end_time = e.ended_at
			atnd_event.event_site = "atnd"

			event_array.push(atnd_event)
		}

		render :json => event_array
	end

end
