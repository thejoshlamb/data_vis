require 'rubygems'
require 'nokogiri'
require 'open-uri'

class String
	def clean
	gsub(/[()]/, "")
	end
end

class Post
	
	attr_accessor :message, :poster, :wants, :location

	def initialize(message,poster,wants,location)
		@message = message
		@poster = poster
		@wants = wants
		@location = location
	end
end

page = Nokogiri::HTML(open("http://toronto.en.craigslist.ca/mis/index.html"))
posts = page.css('p.row')
 
postarray = []

posts.each do |post|
	poster, wants = "m"
	msg = post.css('span.pl a').text.to_s.split(" - ")[0]
	type = post.css('span.pl a').text.to_s.split(" - ")[1]
	poster = type[0] unless type == nil
	wants = type[2] unless type == nil
	location = post.css('span.pnr').text.clean.strip
	postarray << Post.new(msg,poster,wants,location)
end


postarray.each do |post|
	print "it's a #{post.poster}4"
	puts "#{post.wants}"
	puts "message: #{post.message}"
	puts "location: #{post.location}s"
end



# File.open('clmc.html', 'w') do |f|
# 	f.puts "<!DOCTYPE html>"
# 	f.puts "<html>"
# 	f.puts "<head>"
# 	f.puts "<title>mist conex</title>"
# 	f.puts "</head>"
# 	f.puts "<body>"
# 	f.puts "<h1> connected connections: </h1>"
# 	f.puts "<ol>"

# 	posts.each do |post|
# 		f.puts "		<li> "
# 		f.puts "			" + post.at_css("a").text
# 		f.puts "		</li>"
# 	end

# 	f.puts "</body>"
# 	f.puts "</html>"
# end

