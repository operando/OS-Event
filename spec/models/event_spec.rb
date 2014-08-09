require 'spec_helper'

describe Event do

  describe 'Event.connpass_url' do
    let(:base_url) { 'http://connpass.com/api/v1/event/?nickname=operandoOS' }

    it 'should create a url with a query string when a parameter is given' do
      expect(Event.connpass_url(ymd: '20140809')).to eq(base_url + '&ymd=20140809')
    end

    it 'should create a url with query strings when a parameter is given' do
      expect(Event.connpass_url(ymd: '20140809', start: 1)).to eq(base_url + '&start=1&ymd=20140809')
    end

    it 'should create an expected url without a parameter' do
      expect(Event.connpass_url).to eq(base_url)
    end
  end
end
