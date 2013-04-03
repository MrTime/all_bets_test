require 'rubygems'
require 'bundler/setup'

require './lib/parser'

parser = Parser.new :sport_id => 11
parser.parse do |bet|
  puts "event: #{bet[:event_id]} category: #{bet[:category]} bet: #{bet[:bet]}"
end
