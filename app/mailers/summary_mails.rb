class SummaryMails < ActionMailer::Base
  layout 'mail'
  default from: ENV['MAILS_FROM']

  def summary(urls,faults)
    @to = ENV['MAILS_TO']
    @urls = urls
    @faults = faults
    mail to: @to, subject: 'Scraping Summary'
  end

end