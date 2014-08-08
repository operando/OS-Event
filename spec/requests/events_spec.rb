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
        fixture: 'connpass_event_with_nickname.json',
        result: 2
      },
      zusaar: {
        url: 'http://www.zusaar.com/api/event/?user_id=agxzfnp1c2Fhci1ocmRyFgsSBFVzZXIiDDMzMzk4OTM5MV90dww',
        fixture: 'zusaar_event_with_id.json',
        result: 0
      },
      atnd: {
        url: 'http://api.atnd.org/events/?nickname=operando&format=json',
        fixture: 'atnd_event_with_nickname.json',
        result: 5
      }
    }

    before do
      SERVICES.each do |key, value|
        stub_request(:get, value[:url]).to_return(:status => 200, :body => fixture(value[:fixture]))
      end
    end

    describe 'GET /event' do
      before do
        get '/event', format: :json
      end

      let(:json) { JSON.parse(response.body) }

      it 'should return events from today' do
        expect(json.size).to eq 7
      end
    end

    SERVICES.each do |key, value|
      describe "GET /event/#{key.to_s}" do
        before do
          get "/event/#{key.to_s}", format: :json
        end

        let(:json) { JSON.parse(response.body) }

        it 'should return events from today' do
          expect(json.size).to eq value[:result]
        end
      end
    end

    describe 'GET /event/foobarbaz' do
      before do
        get "/event/foobarbaz", format: :json
      end

      let(:json) { JSON.parse(response.body) }

      it 'should return empty array' do
        expect(json.size).to eq 0
      end
    end
  end
end
