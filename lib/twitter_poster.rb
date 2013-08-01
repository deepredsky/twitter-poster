require 'net/http'
require 'json'
require 'twitter'

module TwitterPoster
  def self.post
    quote = Resource.get.to_s
    unless quote == ''
      Client.post quote
    end
  end

  class Resource
    def url
      URI("http://www.iheartquotes.com/api/v1/random?format=json&max_characters=120")
    end

    def get_quote
      parsed_response(Net::HTTP.get(url))
    end

    def quote
      result = get_quote
      result['quote']
    end

    def self.get
      new.quote
    end

    private
    def parsed_response response
      JSON.create_id = nil
      JSON.parse response
    end
  end

  class Client
    def post
    end

    def self.post quote
      Twitter.update(quote)
    end
  end
end
