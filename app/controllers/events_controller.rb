class EventsController < ApplicationController

  def event
    @events = Event.select { |e| e.start_time > Time.now }
  end

  def simple
    if File.exist?(Rails.root.join('tmp','event_simple_cache.json'))
      # p time_now - File.stat(Rails.root.join('tmp','event_simple_cache.json')).mtime
      event_simple_cache = File.read(Rails.root.join('tmp','event_simple_cache.json'),:encoding => Encoding::UTF_8)  
      render :json => event_simple_cache
    else
      events = Event.select { |e| e.start_time > Time.now }
      @events = Event.sort_by_start_time_asc events
      # File.open(Rails.root.join('tmp','event_simple_cache.json'),'w') { |file| file.write events.to_json } 
    end
  end

  def week
    time_now = Time.now
    events = Event.select { |e| time_now < e.start_time and time_now.end_of_week > e.start_time }
    @events = Event.sort_by_start_time_asc events
  end

  def today
    events = Event.select(ymd: Time.now.strftime("%Y%m%d"))
    @events = Event.sort_by_start_time_asc events
  end

  def history
    events = Event.select { |e| e.start_time < Time.now }
    @events = Event.sort_by_start_time_desc events
  end

end
