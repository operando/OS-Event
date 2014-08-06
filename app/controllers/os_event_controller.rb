require 'open-uri'
require 'json'
require 'hashie/mash'
require 'open_uri_redirections'

class OsEventController < ApplicationController

  def event
    event_site = params[:event_site]

    event_array = Array.new
    time_now = Time.now

    if event_site == "connpass" or event_site == nil
      connpass_event_mash = Event.connpass_event_mash
      connpass_event_mash.events.each { |e| event_array.push(Event.build_connpass_event(e)) if time_now < e.started_at }
    end

    if event_site == "zusaar" or event_site == nil
      zusaar_mash = Hashie::Mash.new(JSON.parse(open("http://www.zusaar.com/api/event/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww", :allow_redirections => :all).read))

      zusaar_mash.event.each do |e|
        if time_now < e.started_at
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
      end
    end

    if event_site == "atnd" or event_site == nil
      atnd_mash = Hashie::Mash.new(JSON.parse(open("http://api.atnd.org/events/?nickname=operando&format=json", :allow_redirections => :all).read))

      atnd_mash.events.each do |e|
        if time_now < e.event.started_at
          atnd_event = Event.new

          atnd_event.title = e.event.title
          atnd_event.url = e.event.event_url
          atnd_event.address = e.event.address
          atnd_event.description = e.event.description
          atnd_event.start_time = e.event.started_at
          atnd_event.end_time = e.event.ended_at
          atnd_event.event_site = "atnd"

          event_array.push(atnd_event)
        end
      end
    end

    #event_array.sort! { |a, b| a.start_time <=> b.start_time }

    #  File.open(Rails.root.join('tmp','event_cache.json'),'w') { |file| file.write event_array.to_json } if event_site == nil 

    @events = event_array
  end

  def simple
    event_site = params[:event_site]

    time_now = Time.now

    if File.exist?(Rails.root.join('tmp','event_simple_cache.json')) and event_site == nil
      # p time_now - File.stat(Rails.root.join('tmp','event_simple_cache.json')).mtime
      event_simple_cache = File.read(Rails.root.join('tmp','event_simple_cache.json'),:encoding => Encoding::UTF_8)  
      render :json => event_simple_cache
    else
      event_array = Array.new

      if event_site == "connpass" or event_site == nil
        connpass_event_mash = Event.connpass_event_mash
        connpass_event_mash.events.each { |e| event_array.push(Event.build_connpass_event(e)) if time_now < e.started_at }
      end

      if event_site == "zusaar" or event_site == nil
        zusaar_mash = Hashie::Mash.new(JSON.parse(open("http://www.zusaar.com/api/event/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww", :allow_redirections => :all).read))

        zusaar_mash.event.each do |e|
          if time_now < e.started_at
            zusaar_event = Event.new

            zusaar_event.title = e.title
            zusaar_event.url = e.event_url
            zusaar_event.address = e.address
            zusaar_event.start_time = e.started_at
            zusaar_event.end_time = e.ended_at
            zusaar_event.event_site = "zusaar"

            event_array.push(zusaar_event)
          end
        end
      end

      if event_site == "atnd" or event_site == nil
        atnd_mash = Hashie::Mash.new(JSON.parse(open("http://api.atnd.org/events/?nickname=operando&format=json", :allow_redirections => :all).read))

        atnd_mash.events.each do |e|
          if time_now < e.event.started_at
            atnd_event = Event.new

            atnd_event.title = e.event.title
            atnd_event.url = e.event.event_url
            atnd_event.address = e.event.address
            atnd_event.start_time = e.event.started_at
            atnd_event.end_time = e.event.ended_at
            atnd_event.event_site = "atnd"

            event_array.push(atnd_event)
          end
        end
      end

      event_array.sort! { |a, b| a.start_time <=> b.start_time }
      # File.open(Rails.root.join('tmp','event_simple_cache.json'),'w') { |file| file.write event_array.to_json } if event_site == nil 

      @events = event_array
    end
  end

  def week
    event_site = params[:event_site]

    event_array = Array.new
    time_now = Time.now

    if event_site == "connpass" or event_site == nil
      connpass_event_mash = Event.connpass_event_mash
      connpass_event_mash.events.each { |e| event_array.push(Event.build_connpass_event(e)) if time_now < e.started_at and time_now.end_of_week > e.started_at }
    end

    if event_site == "zusaar" or event_site == nil
      zusaar_mash = Hashie::Mash.new(JSON.parse(open("http://www.zusaar.com/api/event/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww", :allow_redirections => :all).read))

      zusaar_mash.event.each do |e|
        if time_now < e.started_at and time_now.end_of_week > e.started_at
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
      end
    end

    if event_site == "atnd" or event_site == nil
      atnd_mash = Hashie::Mash.new(JSON.parse(open("http://api.atnd.org/events/?nickname=operando&format=json", :allow_redirections => :all).read))

      atnd_mash.events.each do |e|
        if time_now < e.event.started_at and time_now.end_of_week > e.event.started_at
          atnd_event = Event.new

          atnd_event.title = e.event.title
          atnd_event.url = e.event.event_url
          atnd_event.address = e.event.address
          atnd_event.description = e.event.description
          atnd_event.start_time = e.event.started_at
          atnd_event.end_time = e.event.ended_at
          atnd_event.event_site = "atnd"

          event_array.push(atnd_event)
        end
      end
    end

    event_array.sort! { |a, b| a.start_time <=> b.start_time }
    @events = event_array
  end

  def today
    event_site = params[:event_site]

    event_array = Array.new
    time_now = Time.now.strftime("%Y%m%d")
    # test Date
    # time_now = Time.new(2014,7,16).strftime("%Y%m%d")

    if event_site == "connpass" or event_site == nil
      connpass_json_str = open("http://connpass.com/api/v1/event/?nickname=operandoOS&ymd=#{time_now}", :allow_redirections => :all).read
      connpass_event_mash = Hashie::Mash.new(JSON.parse(connpass_json_str))
      connpass_event_mash.events.each { |e| event_array.push(Event.build_connpass_event(e)) }
    end

    if event_site == "zusaar" or event_site == nil
      zusaar_mash = Hashie::Mash.new(JSON.parse(open("http://www.zusaar.com/api/event/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww&ymd=#{time_now}", :allow_redirections => :all).read))

      zusaar_mash.event.each do |e|
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
    end

    if event_site == "atnd" or event_site == nil
      atnd_mash = Hashie::Mash.new(JSON.parse(open("http://api.atnd.org/events/?nickname=operando&format=json&ymd=#{time_now}", :allow_redirections => :all).read))

      atnd_mash.events.each do |e|
        atnd_event = Event.new

        atnd_event.title = e.event.title
        atnd_event.url = e.event.event_url
        atnd_event.address = e.event.address
        atnd_event.description = e.event.description
        atnd_event.start_time = e.event.started_at
        atnd_event.end_time = e.event.ended_at
        atnd_event.event_site = "atnd"

        event_array.push(atnd_event)
      end
    end

    event_array.sort! { |a, b| a.start_time <=> b.start_time }
    @events = event_array
  end

  def history

    event_array = Array.new
    time_now = Time.now

    connpass_event_mash = Event.connpass_event_mash
    connpass_event_mash.events.each { |e| event_array.push(Event.build_connpass_event(e)) if time_now > e.started_at }

    zusaar_mash = Hashie::Mash.new(JSON.parse(open("http://www.zusaar.com/api/event/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww", :allow_redirections => :all).read))

    zusaar_mash.event.each do |e|
      if time_now > e.started_at
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
    end

    atnd_mash = Hashie::Mash.new(JSON.parse(open("http://api.atnd.org/events/?nickname=operando&format=json", :allow_redirections => :all).read))

    atnd_mash.events.each do |e|
      if time_now > e.event.started_at
        atnd_event = Event.new

        atnd_event.title = e.event.title
        atnd_event.url = e.event.event_url
        atnd_event.address = e.event.address
        atnd_event.description = e.event.description
        atnd_event.start_time = e.event.started_at
        atnd_event.end_time = e.event.ended_at
        atnd_event.event_site = "atnd"

        event_array.push(atnd_event)
      end
    end

    event_array.sort! { |a, b| b.start_time <=> a.start_time }

    @events = event_array
  end
end
