class Event < ActiveRecord::Base

  def self.select query = {}, &block
    [].tap do |ary|
      Event.connpass_event_mash.events.each do |e|
        event = Event.build_connpass_event(e)
        if block_given?
          ary.push(event) if yield event
        else
          ary.push(event)
        end
      end
      Event.zusaar_event_mash.event.each do |e|
        event = Event.build_zusaar_event(e)
        if block_given?
          ary.push(event) if yield event
        else
          ary.push(event)
        end
      end
      Event.atnd_event_mash.events.each do |e|
        event = Event.build_atnd_event(e)
        if block_given?
          ary.push(event) if yield event
        else
          ary.push(event)
        end
      end
    end
  end

  def self.connpass_event_mash(query = {})
    Hashie::Mash.new(JSON.parse(open(connpass_url(query), :allow_redirections => :all).read))
  end

  def self.build_connpass_event event_data
    self.new(
      title:       event_data.title,
      url:         event_data.url,
      address:     event_data.address,
      description: event_data.description,
      start_time:  event_data.started_at,
      end_time:    event_data.ended_at,
      event_site:  "connpass")
  end

  def self.zusaar_event_mash(query = {})
    Hashie::Mash.new(JSON.parse(open(zusaar_url(query), :allow_redirections => :all).read))
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

  def self.atnd_event_mash(query = {})
    Hashie::Mash.new(JSON.parse(open(atnd_url(query), :allow_redirections => :all).read))
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

  def self.connpass_url(query = {})
    'http://connpass.com/api/v1/event/?nickname=operandoOS'.tap do |url|
      url << "&#{query.to_query}" unless query.empty?
    end
  end

  def self.zusaar_url(query = {})
    'http://www.zusaar.com/api/event/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww'.tap do |url|
      url << "&#{query.to_query}" unless query.empty?
    end
  end

  def self.atnd_url(query = {})
    'http://api.atnd.org/events/?nickname=operando&format=json'.tap do |url|
      url << "&#{query.to_query}" unless query.empty?
    end
  end
end
