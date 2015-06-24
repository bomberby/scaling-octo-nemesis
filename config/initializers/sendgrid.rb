if Rails.env.test? or Rails.env.development?
  user_name = ENV['SENDGRID_USERNAME']
  password  = ENV['SENDGRID_PASSWORD']
  domain    = ENV['SENDGRID_DOMAIN']
  ActionMailer::Base.default_url_options[:host] = 'www.example.com'

  ActionMailer::Base.smtp_settings = {
    :user_name => user_name,
    :password  => password, 
    :domain    => domain,
    :address   => "smtp.sendgrid.net",
    :port      => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}
end

