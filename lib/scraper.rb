class Scraper
  SCRAPE_SERVICES = [Scrapers::GoogleFinances]
  PUBLISH_SERVICES = [Publishers::Pastebin]
  @faulty_services = []
  def self.scrape_all
    Rails.logger.info 'Scraping all services'
    results = {}
    SCRAPE_SERVICES.each do |service|
      begin 
        results.merge!({service.send('friendly_name') => service.send(:scrape)})
      rescue Exception => e
        @faulty_services << {:type => 'scraper', :name=> service.send('friendly_name'), 
          :details => "Error occured while scraping:#{e.message}\nstack:#{e.backtrace.take(8)}"}
      end
    end

    #failure handling
    errors = {}
    if scraping_list.count > 0
      results.each_pair do |key,value|
        unless value[:stocks].present? #Service returned no results
          errors.merge({key => 'Returned no results'})
          @faulty_services << {:type => 'scraper', :name=> key,:details => 'no results found'}
        end
      end
    end

    published_urls = post_results(results,errors)
    begin 
      SummaryMails.summary(published_urls,@faulty_services).deliver_now
    rescue Exception => e
      Rails.logger.error "Failed to send summary mail!:#{e.message}\nstack:#{e.backtrace.take(8)}"
    end
    results
  end

  def self.scraping_list
    return @list if @list.present?

    #generate url list
    url = ENV['STOCKS_SOURCE']
    Rails.logger.info 'Generating stock list to scrape'
    agent = Agent.instance
    csv = agent.get url
    @list = csv.body.strip.split(',')
  rescue Exception => e
    @faulty_services << {:type => 'url list', :name=> 'url list',:details => 'Failed to load url list'}
    Rails.logger.error "Failed to send summary mail!:#{e.message}\nstack:#{e.backtrace.take(8)}"
    []
  end

  def self.post_results(results,errors)
    published_urls = []
    PUBLISH_SERVICES.each do |service|
      begin 
        res = service.send('publish',results,errors)
        Rails.logger.info "Result posted to #{res}"
        published_urls << res
      rescue Exception => e
        @faulty_services << {:type => 'publisher', :name=> service.send('friendly_name'), 
          :details => "Error occured while scraping:#{e.message}\nstack:#{e.backtrace.take(8)}"}
      end 
    end
    #puts results
    published_urls
  end
end