module Scrapers
  class GoogleFinances
    URL = 'https://www.google.com/finance?q='

    def self.scrape
      Rails.logger.info 'Scrapping google finances'
      results = {}
      Scraper.scraping_list.each do |stock|
        Rails.logger.info "Scraping for #{stock} in google finances"
        res = scrape_stock(stock)
        if res.class == Float
          results.merge!({:stocks => {}}) unless results[:stocks].present?
          results[:stocks].merge!({stock => res})
        else
          results.merge!({:errors => {}}) unless results[:errors].present?
          results.merge!({:errors => {stock => res}})
        end
      end
      return results
    end

    def self.scrape_stock(stock)
      page = agent.get URL + stock.to_s
      res = page.at('#price-panel span.pr span')
      if res.nil?
        return 'No result found'
      end
      res.text.to_f
    end

    def self.agent
      Agent.instance
    end

    def self.friendly_name
      'Google Finances'
    end
  end
end