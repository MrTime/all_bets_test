require 'rubygems'
require 'bundler/setup'

require 'open-uri'
require 'json'
require 'nokogiri'

$prev_call = Time.now.to_f

def time_check
  t = Time.now.to_f
  diff = t - $prev_call
  prev_call = t

  diff
end

started = time_check


list_doc = Nokogiri::HTML(open('http://www.marathonbet.com/ru/tree-node.htm?nodeId=11'))

puts 'leagures:'
count = list_doc.css('a').size
threads = []
list_doc.css('a').each_with_index do |link, index|
  url = "http://www.marathonbet.com/#{link['href']}"
  threads << Thread.new(url) do |url|
    puts "#{index}/#{count} #{url}"

    doc = Nokogiri::HTML(open(url))

    puts "more links"
    doc.css('.event-more-view').each do |link|
      more_view_id = /event-more-view-(\d+)/.match(link['id'])

      more_url = "http://www.marathonbet.com/ru/markets.htm?isHotPrice=false&treeId=#{more_view_id[1]}"
      threads << Thread.new(more_url) do |url|
        puts more_url
        more_json_doc = JSON.parse open(more_url).read
        more_doc = Nokogiri::HTML(more_json_doc['HTML'])

        more_doc.css('.selection-price').each_with_index do |link,i|
          if i%2 == 0
            params = /(\d+)@(\w*).(.*)/.match(link['id'])
            puts "event: #{params[1]} category: #{params[2]} bet: #{params[3]}"
          end
        end
      end


    end

    puts "bets"
    doc.css('.selection-price').each_with_index do |link,i|
      if i%2 == 0
        params = /(\d+)@(\w*).(.*)/.match(link['id'])
        puts "event: #{params[1]} category: #{params[2]} bet: #{params[3]}"
      end
    end
  end
end

threads.each {|t| t.join }

#more_links_time = time_check

#bets_time = time_check

total_time = Time.now.to_f
puts "total time #{total_time}"
