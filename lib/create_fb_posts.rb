#!/usr/bin/env ./script/runner


events = Event.all()
client = Mogli::Client.new('1402669323')

events.first.post_to_fb_page(client)

#puts " client #{client.inspect}"



#events.each do |e|
  
 # e.post_to_fb_page(client)
  
  
#end
