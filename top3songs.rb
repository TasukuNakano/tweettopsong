#encoding: utf-8
require 'open-uri'
require 'rexml/document'
require 'twitter'

#get information from iTunes Store
url = 'https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?genreId=34&id=1000&popId=1'
content = String.new
open(url,"User-Agent" => "iTunes/12.0.1 (Macintosh; OS X 10.10.1) AppleWebKit/0600.1.25","X-Apple-Store-Front" => "143462-9"){|f|
  f.each_line {|line| content += line}
}
doc = REXML::Document.new(content)

songs = Array.new
artists = Array.new
3.times do |i|
  elem = doc.elements["Document/TrackList/plist/dict/array/dict[#{i+1}]"]
  array = Array.new elem.map(&:to_s)
  j = 0
  array.each do |c|
   if c =~ /artistName/ # artist name
     artists.push array[j + 1].gsub(/<\/?[^>]*>/, "")
   end

   if c =~ /itemName/ # song name
     songs.push array[j + 1].gsub(/<\/?[^>]*>/, "")
     break
   end
   j += 1
  end
end

head = 'TopSongs '
foot = 'from iTunes Store'
s = String.new
s = head
3.times do |i|
  break if s.length > (140-foot.length)
  s += "#{i+1}:#{songs[i]} by #{artists[i]}. "
end
s += foot

#tweet
config = {
  consumer_key: ENV['TWITTER_CONSUMER_KEY'],
  consumer_secret: ENV['TWITTER_CONSUMER_SECRET'],
  access_token: ENV['TWITTER_ACCESS_TOKEN'],
  access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET']
}
client = Twitter::REST::Client.new(config)
client.update s

