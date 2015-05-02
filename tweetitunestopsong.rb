require 'open-uri'
require 'rexml/document'
require 'twitter'

#get information from iTunes Store
url = 'https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?genreId=34&id=1000&popId=1'
content = String.new
open(url, "User-Agent" => "iTunes/12.0.1", "X-Apple-Store-Front" => "143462-9"){|f|
  f.each_line {|line| content += line }
}
doc = REXML::Document.new(content)

elem = doc.elements["Document/TrackList/plist/dict/array/dict"]
array = Array.new elem.map(&:to_s)
j=0
song=Array.new
artist=Array.new
array.each do |c|
 if c =~ /artistName/ then # artist name
   artist = array[j+1].gsub(/<\/?[^>]*>/, "")
 end
 if c =~ /itemName/ then # song name
   song = array[j+1].gsub(/<\/?[^>]*>/, "")
   break
 end
 j+=1
end

#tweet
config = {
  consumer_key: ENV['TWITTER_CONSUMER_KEY'],
  consumer_secret: ENV['TWITTER_CONSUMER_SECRET'],
  access_token: ENV['TWITTER_ACCESS_TOKEN'],
  access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET']
}

client = Twitter::REST::Client.new(config)

client.update("#{song} by #{artist}")
