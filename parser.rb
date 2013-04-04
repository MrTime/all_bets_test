require 'rubygems'
require 'bundler/setup'

require './lib/parser'

events = {}
start_time = Time.now

parser = Parser.new :sport_id => 11
parser.parse do |bet|
  events[bet[:event]] = bet
  bet[:event] = nil
  print "\r bets processed #{bet[:progress]}"
end

puts JSON.pretty_generate(events)

