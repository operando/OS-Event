class Event < ActiveRecord::Base

  SERVICES = {
    connpass: {
      api_url: 'http://connpass.com/api/v1/event/?nickname=operandoOS'
    },
    zusaar: {
      api_url: 'http://www.zusaar.com/api/event/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww'
    },
    atnd: {
      api_url: 'http://api.atnd.org/events/?nickname=operando&format=json'
    }
  }

  def self.select query = {}, &block
    [].tap do |ary|
      Event.mash(api_url(:connpass, query)).events.each do |e|
        event = Event.build_connpass_event(e)
        if block_given?
          ary.push(event) if yield event
        else
          ary.push(event)
        end
      end
      Event.mash(api_url(:zusaar, query)).event.each do |e|
        event = Event.build_zusaar_event(e)
        if block_given?
          ary.push(event) if yield event
        else
          ary.push(event)
        end
      end
      Event.mash(api_url(:atnd, query)).events.each do |e|
        event = Event.build_atnd_event(e)
        if block_given?
          ary.push(event) if yield event
        else
          ary.push(event)
        end
      end
    end
  end

  def self.mash url
    Hashie::Mash.new(JSON.parse(open(url, :allow_redirections => :all).read))
  end

  def self.api_url name, query = {}
    SERVICES[name.to_sym][:api_url].dup.tap do |url|
      url << "&#{query.to_query}" unless query.empty?
    end
  end

  def self.build_connpass_event event_data
    self.new(
      title:       event_data.title,
      url:         event_data.event_url,
      address:     event_data.address,
      description: event_data.description,
      start_time:  event_data.started_at,
      end_time:    event_data.ended_at,
      event_site:  "connpass")
  end

  def self.build_zusaar_event event_data
    self.new(
      title:       event_data.title,
      url:         event_data.event_url,
      address:     event_data.address,
      description: event_data.description,
      start_time:  event_data.started_at,
      end_time:    event_data.ended_at,
      event_site:  'zusaar')
  end

  def self.build_atnd_event event_data
    self.new(
      title:       event_data.event.title,
      url:         event_data.event.event_url,
      address:     event_data.event.address,
      description: event_data.event.description,
      start_time:  event_data.event.started_at,
      end_time:    event_data.event.ended_at,
      event_site:  'atnd')
  end

  def self.sort_by_start_time_asc events
    events.sort { |a, b| a.start_time <=> b.start_time }
  end

  def self.sort_by_start_time_desc events
    events.sort { |a, b| b.start_time <=> a.start_time }
  end
end
