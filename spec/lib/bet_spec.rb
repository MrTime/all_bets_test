require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require './lib/leagure'

describe Bet do

  let(:parser) { Parser.new :sport_id => 11 }
  let(:doc) { Nokogiri::HTML(open('spec/support/bets.html')) }

  BET_VALUES = { :event_id => '805371', 
              :category => 'Match_Result', 
              :koeff => 2.0,
              :bet => '1'}

  it 'should parse all bets' do
    results = []
    Bet.parse(doc) do |result|
      results << result;
    end

    results.size.should eq 4
  end

  BET_VALUES.each_pair do |key,value|
    it "should parse #{key.to_s}" do
      results = []
      Bet.parse(doc) do |result|
        results << result;
      end

      results[0][key].should eq value
    end
  end

  it 'should parse value of bet' do
    results = []
    Bet.parse(doc) do |result|
      results << result;
    end

    results[0][:value].should be_nil
    results[1][:value].should eq '-1'
    results[2][:value].should eq '+1'
    results[3][:value].should eq '2.5'
  end
end
