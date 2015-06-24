require 'rails_helper'

describe Scrapers::GoogleFinances do
  it 'should have a value for GOOG' do
    expect(Scrapers::GoogleFinances.scrape_stock('GOOG')).to be == 540.48
  end
  it 'should give error for not found stock' do
    expect(Scrapers::GoogleFinances.scrape_stock('ZAZA')).to eql 'No result found'
  end
  
  it 'should empty results for scraping empty list' do
    allow(Scraper).to receive(:scraping_list).and_return([])
    expect(Scrapers::GoogleFinances.scrape).to eql Hash.new
  end

  it 'should return true for scraping GOOG only' do
    allow(Scraper).to receive(:scraping_list).and_return(['GOOG'])
    expect(Scrapers::GoogleFinances).to receive(:scrape_stock).and_return(540.48).once

    expect(Scrapers::GoogleFinances.scrape).to eql({:stocks=>{"GOOG"=>540.48}})
  end
  it 'should return error for scraping ZAZA' do
    allow(Scraper).to receive(:scraping_list).and_return(['ZAZA'])
    expect(Scrapers::GoogleFinances).to receive(:scrape_stock).and_return('No result found').once

    expect(Scrapers::GoogleFinances.scrape).to eql({:errors=>{"ZAZA"=>'No result found'}})
  end
end