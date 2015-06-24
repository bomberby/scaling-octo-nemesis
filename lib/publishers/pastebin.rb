module Publishers
  class Pastebin
    require 'rest_client'

    #api information: http://pastebin.com/api
    URL = 'http://pastebin.com/api/api_post.php'

    def self.publish(results,errors)
      Rails.logger.info "Posting information to Pastebin"

      string = build_string(results,errors)
      return post_data(string)
    end
    def self.build_string(results,errors)
      "Results:\n#{results.to_s}\n\nErrors:#{errors.to_s}"
    end
    def self.post_data(string)
      RestClient.post URL, {:api_dev_key => ENV['PASTEBIN_DEV_KEY'], :api_option => 'paste', :api_paste_code => string}
    end

    def self.friendly_name
      'Pastebin'
    end
  end
end