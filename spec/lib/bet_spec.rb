require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require './lib/leagure'

describe Bet do

  let(:parser) { Parser.new :sport_id => 11 }
  let(:doc) { Nokogiri::HTML(open('spec/support/bets.html')) }

  BET_VALUES = { :event_id => '805371', 
              :category => 'Match_Result', 
              :bet => '1'}

  BET_VALUES.each_pair do |key,value|
    it "should parse #{key.to_s}" do
      Bet.parse(doc) do |result|
        result[key].should eq value
      end
    end
  end
end
