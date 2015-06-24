desc 'Pull data from all sources'
task :scrape  => :environment do
  Scraper.scrape_all
end