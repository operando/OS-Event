require 'spec_helper'

describe Event do

  attrs = %i[title url address description start_time end_time event_site]

  describe 'each attributes' do
    let(:event) do
      Event.new(
      title: '第20回ゆるびぃ会',
      url: 'https://github.com/yuruby',
      address: '東京都渋谷区渋谷2-21-1 渋谷ヒカリエ 11F',
      description: 'ゆるびぃ会です。',
      start_time: '2014-09-26T19:00:00.000+09:00',
      end_time: '2014-09-26T21:30:00.000+09:00',
      event_site: 'connpass')
    end

    attrs.each do |attribute|
      it "should respond to #{attribute.to_s}" do
        expect(event).to respond_to(attribute)
      end
    end
  end

  describe 'Event.build_connpass_event' do
    before do
      url  = 'http://connpass.com/api/v1/event/?nickname=operandoOS'
      json = 'connpass_event_with_nickname.json'
      stub_request(:get, url).to_return(:status => 200, :body => fixture(json))
    end

    let(:mash) { Event.mash('http://connpass.com/api/v1/event/?nickname=operandoOS').events.first }
    let(:event) { Event.build_connpass_event(mash) }

    attrs.each do |attribute|
      it "should respond to #{attribute.to_s}" do
        expect(event).to respond_to(attribute)
      end
    end
  end

  describe 'Event.api_url' do
    let(:base_url) { 'http://connpass.com/api/v1/event/?nickname=operandoOS' }

    it 'should create a url with a query string when a parameter is given' do
      expect(Event.api_url(:connpass, ymd: '20140809')).to eq(base_url + '&ymd=20140809')
    end

    it 'should create a url with query strings when a parameter is given' do
      expect(Event.api_url(:connpass, ymd: '20140809', start: 1)).to eq(base_url + '&start=1&ymd=20140809')
    end

    it 'should create an expected url without a parameter' do
      expect(Event.api_url(:connpass)).to eq(base_url)
    end
  end
end
