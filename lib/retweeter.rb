require 'pstore'
require 'twitter'
require 'active_support/all'

class Retweeter
  def initialize(query)
    @query = query
  end

  def run
    options = {
      :result_type => "recent",
      :lang => :en,
      :count => 5
    }
    options[:since_id] = since_id unless since_id.nil?
    result = client.search(search_query.to_s, options).take(5)
    if result.first
      last_id = result.first.id
      result.each do |tweet|
        p tweet.id

        begin
          client.retweet(tweet)
        rescue Exception => e
          puts "error retweeting"
          puts e.message
        end
      end
      Store.new.save(search_query.since_id, last_id)
    end
  end

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = "YDW9InpRAqwxDlvb1Pl7A"
      config.consumer_secret     = "UzfQGPKwz0FA97bpzhYC4UPw0uByAguWN4JELpnzL4"
      config.access_token        = "19751408-F3lJL5vx5uLGKh6zEe3ghAgdnTZwO9FEAGzsNQa0"
      config.access_token_secret = "Zw0mE68gcTt1BTAeAxrFdlPMRGMVaN14YtoAV2c3DY"
    end
  end

  def self.run(query)
    new(query).run
  end

  private

  def search_query
    @search_query ||= SearchQuery.new(@query)
  end

  def since_id
    Store.new.read(search_query.since_id)
  end
end

class Store
  def save(name, value)
    store_name.transaction do
      store_name[name] = value
    end
  end

  def read(name)
    store_name.transaction(true) do
      store_name[name]
    end
  end

  private
  def store_name
    @store_name ||= PStore.new("last.pstore")
  end
end

class SearchQuery
  def initialize(phrase)
    @phrase = phrase
  end

  def since_id
    @phrase.to_s.parameterize + '_since_id'
  end

  def to_s
    @phrase.to_s
  end
end
