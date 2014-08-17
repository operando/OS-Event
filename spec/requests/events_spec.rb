require 'spec_helper'

describe 'EventsController' do
  before do
    Timecop.freeze(Time.local(2014, 7, 24, 12, 0, 0))
  end

  after do
    Timecop.return
  end

  describe 'event' do
    SERVICES = {
      connpass: {
        url: 'http://connpass.com/api/v1/event/?nickname=operandoOS',
        fixture: 'connpass_event_with_nickname.json'
      },
      zusaar: {
        url: 'http://www.zusaar.com/api/event/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww',
        fixture: 'zusaar_event_with_id.json'
      },
      atnd: {
        url: 'http://api.atnd.org/events/?nickname=operando&format=json',
        fixture: 'atnd_event_with_nickname.json'
      }
    }

    before do
      SERVICES.each do |key, value|
        stub_request(:get, value[:url]).to_return(:status => 200, :body => fixture(value[:fixture]))
      end
    end

    describe 'GET /events' do
      before do
        get '/events', format: :json
      end

      let(:json) { JSON.parse(response.body) }

      it 'should return events from today' do
        expect(json.size).to eq 8
      end
    end

    describe 'GET /events/simple' do
      before do
        get '/events/simple', format: :json
      end

      let(:json) { JSON.parse(response.body) }

      it 'should return events from today' do
        expect(json.size).to eq 8
      end
    end

    describe 'GET /events/week' do
      before do
        get '/events/week', format: :json
      end

      let(:json) { JSON.parse(response.body) }

      it 'should return events in this week' do
        expect(json.size).to eq 2
      end
    end

    describe 'GET /events/history' do
      before do
        get '/events/history', format: :json
      end

      let(:json) { JSON.parse(response.body) }

      it 'should return events before now' do
        expect(json.size).to eq 21
      end
    end
  end
end
