require 'open-uri'
require 'json'
require 'hashie/mash'
require 'open_uri_redirections'

class EventsController < ApplicationController

  def event
    events = Event.select { |e| e.start_time > Time.now }
    render :json => events
  end

  def simple
    if File.exist?(Rails.root.join('tmp','event_simple_cache.json'))
      # p time_now - File.stat(Rails.root.join('tmp','event_simple_cache.json')).mtime
      event_simple_cache = File.read(Rails.root.join('tmp','event_simple_cache.json'),:encoding => Encoding::UTF_8)  
      render :json => event_simple_cache
    else
      events = Event.select { |e| e.start_time > Time.now }
      events.sort! { |a, b| a.start_time <=> b.start_time }
      # File.open(Rails.root.join('tmp','event_simple_cache.json'),'w') { |file| file.write events.to_json } 
      render :json => events
    end
  end

  def week
    time_now = Time.now
    events = Event.select { |e| time_now < e.start_time and time_now.end_of_week > e.start_time }
    events.sort! { |a, b| a.start_time <=> b.start_time }
    render :json => events
  end

  def today
    events = Event.select(ymd: Time.now.strftime("%Y%m%d"))
    events.sort! { |a, b| a.start_time <=> b.start_time }
    render :json => events
  end

  def history
    events = Event.select { |e| e.start_time < Time.now }
    events.sort! { |a, b| b.start_time <=> a.start_time }
    render :json => events
  end
end
