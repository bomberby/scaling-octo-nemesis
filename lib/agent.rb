require 'singleton'

class Agent < Mechanize
  include Singleton

  def initialize
    super
  end

  def get(url) # wrap mechanize get with VCR
    VCR.use_cassette(url ) do
      super(url)
    end
  end
end