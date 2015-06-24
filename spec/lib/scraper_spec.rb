require 'rails_helper'

describe Scraper do
  it 'should get good stock list' do
    expect(Scraper.scraping_list).to eql(['GOOG','AMZN']) #values from VCR
  end
  describe 'when scraping all' do
    it 'should call all scrapers' do
      scraper_mock = double
      stub_const("Scraper::SCRAPE_SERVICES", [scraper_mock])
      expect(scraper_mock).to receive(:scrape).and_return({:stocks => {'GOOG' => 1111}}).once
      allow(scraper_mock).to receive(:friendly_name).and_return('Mock Scrapper')
      stub_const("Scraper::PUBLISH_SERVICES", []) #don't try to publish anything
      Scraper.scrape_all
    end
  end

  describe 'when encountering problems' do
    xit 'should notify of a service not returning any result'
    xit 'should notify of a stock no service returns results for'
    xit 'should handle execption on scraper'
    xit 'should include errors in email'
  end

  describe 'should post results' do
    it 'to all publishers' do
      publisher_mock = double
      stub_const("Scraper::PUBLISH_SERVICES", [publisher_mock])
      expect(publisher_mock).to receive(:publish).with('results','errors').and_return('LINK').once
      Scraper.post_results('results','errors')      
    end
    xit 'should handle exception in poster'
  end
  xit 'should send emails when scraping finishes'
end