require 'rubygems'
require 'bundler/setup'

require './lib/parser'

parser = Parser.new :sport_id => 11
parser.parse
