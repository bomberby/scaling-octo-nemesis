if Rails.env.production? or Rails.env.development?# or Rails.env.test?
  # Dummy VCR
  class VCR
    def self.use_cassette(url)
      yield
    end
  end
else
  VCR.configure do |c|
    c.allow_http_connections_when_no_cassette = true
    c.cassette_library_dir = 'vcr_cassettes'
    c.hook_into :webmock
    c.ignore_request do |request|
      request.uri =~ /amazonaws/ or
      request.uri =~ /localhost/ 
    end
  end
end