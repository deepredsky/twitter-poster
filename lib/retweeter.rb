require 'PStore'
require 'twitter'

class Retweeter
  def run
    options = {
      :result_type => "recent",
      :count => 10
    }
    options[:since_id] = since_id unless since_id.nil?
    result = client.search('#nepal #travel -rt', options).take(10)
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
      Store.new.save("since_id", last_id)
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

  def since_id
    Store.new.read("since_id")
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
