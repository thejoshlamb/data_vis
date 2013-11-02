require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("http://toronto.en.craigslist.ca/eng/"))
posts = page.css('p.row span.pl')
words = []
ignore = ["for","canada","software","assistant","and","senior","toronto","marketing","account","manager"]

class String
	def clean
	gsub(/[(),\/]/, "")
	end
end

posts.each do |post| 
	post_string = post.at_css('a').text.to_s.downcase.split(" ")
	post_string.each do |word|
		words << word.clean
	end
end

words.delete_if { |word| ignore.include?("#{word}")}
words.delete_if { |word| word.length <= 3}

wordcounter = Hash.new(0)

words.each do |word|
	wordcounter[word] += 1
end

ranked_list = wordcounter.sort_by{ |key, value| -value }  

ranked_list.compact!


File.open('numbers.html', 'w') do |f|
	f.puts "<!DOCTYPE html>"
	f.puts "<html>"
	f.puts "	<head>"
	f.puts "		<title>devs wanted</title>"
	f.puts "		<link rel='stylesheet' type='text/css' href='numbers.css'/>"
	f.puts "	</head>"
	f.puts "<body>"
	f.puts "	<div class='words'>"
	(0..19).each do |rank|
		fontsize = ranked_list[rank][1] * 8.5
			f.puts "<p><span style = 'font-size:"+fontsize.to_s+"px'>"
			f.puts ranked_list[rank][0]
			f.puts "</span></p>"
	end
	# f.puts "		<ol>"
	# posts.each do |post|
	# 	f.puts "			<li> "
	# 	f.puts "				" + post.at_css("a").text
	# 	f.puts "			</li>"
	# end
	# f.puts "		</ol>"
	f.puts "	</div>"
	f.puts "</body>"
	f.puts "</html>"
end

