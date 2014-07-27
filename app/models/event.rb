class Event < ActiveRecord::Base

  def self.connpass_event_mash
    Hashie::Mash.new(JSON.parse(open("http://connpass.com/api/v1/event/?nickname=operandoOS", :allow_redirections => :all).read))
  end

  def self.build_connpass_event event_data
    self.new(title: event_data.title, url: event_data.url, address: event_data.address, description: event_data.description, start_time: event_data.started_at, end_time: event_data.ended_at, event_site: "connpass")
  end
end
