require 'rubygems'
require 'nokogiri'
require 'open-uri'

class String
	def clean
	gsub(/[‘’]/, "'")
	end
end

page = Nokogiri::HTML(open("http://www.thestar.com/search.html?q=rob+ford"))
headlines = page.css('p.headline')
images = page.css('li.float-clear a img')

images.each do |img| 
	puts "----------------------------------------------------"
	puts img
	puts "----------------------------------------------------"
end


File.open('ford.html', 'w') do |f|
	f.puts "<!DOCTYPE html>"
	f.puts "<html>"
	f.puts "<head>"
	f.puts "<title>What's Ford up to?</title>"
	f.puts "</head>"
	f.puts "<body>"
	f.puts "<h1> Here's what Rob's up to: </h1>"
	f.puts "<ol>"

	headlines.each do |hl|
		f.puts "		<li> "
		# f.puts "			<span>" + headline.at_css('span.date').text +"</span>"
		f.puts "			" + hl.at_css("a").text.clean
		f.puts "		</li>"
	end

	images.each do |img|
		f.puts "<img src=\"" + img['data-original'] + "\">"
	end

	f.puts "</body>"
	f.puts "</html>"
end

