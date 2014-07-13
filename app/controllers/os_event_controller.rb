require 'open-uri'
require 'json'
require 'hashie/mash'

class OsEventController < ApplicationController

	def event

		event_site = params[:event_site]

		event_array = Array.new
		time_now = Time.now

		if event_site == "connpass" or event_site == nil then
			connpass_json_str = open("http://connpass.com/api/v1/event/?nickname=operandoOS").read

			connpass_event_mash = Hashie::Mash.new(JSON.parse(connpass_json_str))

			connpass_event_mash.events.each { |e|
				if time_now < e.started_at then
					connpass_event = Event.new 
					
					connpass_event.title = e.title
					connpass_event.url = e.event_url
					connpass_event.address = e.address		
					connpass_event.description = e.description
					connpass_event.start_time = e.started_at
					connpass_event.end_time = e.ended_at
					connpass_event.event_site = "connpass"

					event_array.push(connpass_event)
				end
			}
		end

		if event_site == "zusaar" or event_site == nil then
			zusaar_mash = Hashie::Mash.new(JSON.parse(open("http://www.zusaar.com/api/event/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww").read))

			zusaar_mash.event.each { |e|
				if time_now < e.started_at then
					zusaar_event = Event.new 
					
					zusaar_event.title = e.title
					zusaar_event.url = e.event_url
					zusaar_event.address = e.address
					zusaar_event.description = e.description
					zusaar_event.start_time = e.started_at
					zusaar_event.end_time = e.ended_at
					zusaar_event.event_site = "zusaar"

					event_array.push(zusaar_event)
				end
			}
		end

		if event_site == "atnd" or event_site == nil then
			atnd_mash = Hashie::Mash.new(JSON.parse(open("http://api.atnd.org/events/?nickname=operando&format=json").read))

			atnd_mash.events.each { |e|
				if time_now < e.started_at then
					atnd_event = Event.new 
					
					atnd_event.title = e.title
					atnd_event.url = e.event_url
					atnd_event.address = e.address		
					atnd_event.description = e.description
					atnd_event.start_time = e.started_at
					atnd_event.end_time = e.ended_at
					atnd_event.event_site = "atnd"

					event_array.push(atnd_event)
				end
			}
		end

		event_array.sort!{|a,b| a.start_time <=> b.start_time }

		render :json => event_array
	end

	def simple
		event_site = params[:event_site]

		event_array = Array.new
		time_now = Time.now

		if event_site == "connpass" or event_site == nil then
			connpass_json_str = open("http://connpass.com/api/v1/event/?nickname=operandoOS").read
			
			connpass_event_mash = Hashie::Mash.new(JSON.parse(connpass_json_str))

			connpass_event_mash.events.each { |e|
				if time_now < e.started_at then
					connpass_event = Event.new 
					
					connpass_event.title = e.title
					connpass_event.url = e.event_url
					connpass_event.address = e.address		
					connpass_event.start_time = e.started_at
					connpass_event.end_time = e.ended_at
					connpass_event.event_site = "connpass"

					event_array.push(connpass_event)
				end
			}
		end

		if event_site == "zusaar" or event_site == nil then
			zusaar_mash = Hashie::Mash.new(JSON.parse(open("http://www.zusaar.com/api/event/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww").read))

			zusaar_mash.event.each { |e|
				if time_now < e.started_at then
					zusaar_event = Event.new 
					
					zusaar_event.title = e.title
					zusaar_event.url = e.event_url
					zusaar_event.address = e.address
					zusaar_event.start_time = e.started_at
					zusaar_event.end_time = e.ended_at
					zusaar_event.event_site = "zusaar"

					event_array.push(zusaar_event)
				end
			}
		end

		if event_site == "atnd" or event_site == nil then
			atnd_mash = Hashie::Mash.new(JSON.parse(open("http://api.atnd.org/events/?nickname=operando&format=json").read))

			atnd_mash.events.each { |e|
				if time_now < e.started_at then
					atnd_event = Event.new 
					
					atnd_event.title = e.title
					atnd_event.url = e.event_url
					atnd_event.address = e.address		
					atnd_event.start_time = e.started_at
					atnd_event.end_time = e.ended_at
					atnd_event.event_site = "atnd"

					event_array.push(atnd_event)
				end
			}
		end

		event_array.sort!{|a,b| a.start_time <=> b.start_time }

		render :json => event_array
	end

end
