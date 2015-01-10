require 'open-uri'
require 'rexml/document'
require 'twitter'

#get information from iTunes Store
url='https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?genreId=34&id=1000&popId=1'
content=String.new
open(url,"User-Agent" => "iTunes/12.0.1","X-Apple-Store-Front" => "143462-9"){|f|
  f.each_line {|line| content+=line}
}
doc = REXML::Document.new(content)

song = String.new
if doc.elements['Document/TrackList/plist/dict/array/dict[1]/string[6]'].text =~ /[0-9]+/ then
  song = doc.elements['Document/TrackList/plist/dict/array/dict[1]/string[8]'].text
else
  song = doc.elements['Document/TrackList/plist/dict/array/dict[1]/string[6]'].text
end
artist = String.new doc.elements['Document/TrackList/plist/dict/array/dict[1]/string'].text

#tweet
consumer_key = ''
consumer_secret = ''
access_token = ''
access_token_secret = ''

config = {
  consumer_key: consumer_key,
  consumer_secret: consumer_secret,
  access_token: access_token,
  access_token_secret: access_token_secret
}

client = Twitter::REST::Client.new(config)

client.update("#{song} by #{artist}")
