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


  def parse &block
    doc = Nokogiri::HTML(open(leagures_url))
    doc.css('a').each do |link|
      start_task(link) do |link|
        options = {
          :href => link['href'], 
          :name => link.inner_text.strip,
          :parser => self
        }
        Leagure.parse options, &block
      end
    end

    wait_for_tasks
  end

  def start_task options = {}, &block
    @threads << Thread.new(options, &block)
  end

  def wait_for_tasks
    @threads.each {|t| t.join }
  end

  def leagures_url
    "http://www.marathonbet.com/ru/tree-node.htm?nodeId=#{@sport_id}"
  end
end
