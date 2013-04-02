require 'rubygems'
require 'bundler/setup'

require 'open-uri'
require 'json'
require 'nokogiri'

require './lib/leagure'

class Parser
  attr_reader :sport_id, :threads

  def initialize options
    @sport_id = options[:sport_id]
    @threads = []
  end

  def url
    "http://www.marathonbet.com/ru/tree-node.htm?nodeId=#{@sport_id}"
  end

  def get_page
    open(url)
  end

  def parse
    doc = Nokogiri::HTML(get_page)
    doc.css('a').each do |link|
      @threads << Thread.new(link) do |link|
        Leagure.parse :href => link['href'], 
          :name => link.inner_text,
          :parser => self
      end
    end

    @threads.each {|t| t.join }
  end

  def start_task options = {}, &block
    @threads << Thread.new(options, block)
  end

  def parse_doc_bets(doc)
    doc.css('.selection-price').each_with_index do |link,i|
      if i%2 == 0
        params = /(\d+)@(\w*).(.*)/.match(link['id'])
        event_id, category, bet = params[1..3]
        puts "event: #{event_id} category: #{category} bet: #{bet}"
      end
    end
  end


end
