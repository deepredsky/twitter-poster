require 'spec_helper'
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'twitter_poster')

describe TwitterPoster do
  context "#post" do
    it "grabs a random text from api" do
      TwitterPoster::Resource.should_receive(:get)
      TwitterPoster.post
    end

    it "posts the resource to twitter" do
      TwitterPoster::Resource.stub(:get).and_return("quote")
      TwitterPoster::Client.should_receive(:post)
      TwitterPoster.post
    end

    it "does not post to twitter with empty quote" do
      TwitterPoster::Resource.stub(:get).and_return("")
      TwitterPoster::Client.should_receive(:post).never()
      TwitterPoster.post
    end
  end
end

describe TwitterPoster::Client do
  context "post" do
    it "delegates to the client post method" do
      Twitter.should_receive(:update).with('something')
      TwitterPoster::Client.post 'something'
    end
  end
end

describe TwitterPoster::Resource do
  context "get" do
    it "fetches a random quote from external service" do
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(:get, "http://www.iheartquotes.com/api/v1/random?format=json&max_characters=120", body: resource_mock)
      expect(TwitterPoster::Resource.get).to eql("a random quote")
    end

    def resource_mock
      <<-EOF
        {"json_class":"Fortune","tags":["platitudes"],"quote":"a random quote","link":"http://iheartquotes.com/fortune/show/51026","source":"fortune"}
      EOF
    end
  end
end
