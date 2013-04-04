require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require './lib/leagure'

describe Bet do

  let(:parser) { Parser.new :sport_id => 11 }
  let(:doc) { Nokogiri::HTML(open('spec/support/bets.html')) }
  let(:results) do
    results = []
    Bet.parse(doc) do |result|
      results << result;
    end
    results
  end

  BET_VALUES = { :event_id => '805371', 
              :category => 'Match_Result.1', 
              :koeff => 2.0,
              :rel => 'rel'}

  it 'should parse all bets' do
    results.size.should eq 6
  end

  BET_VALUES.each_pair do |key,value|
    it "should parse #{key.to_s}" do
      results[0][key].should eq value
    end
  end

  it 'should parse value of bet' do
    results[0][:value].should be_nil
    results[1][:value].should eq '-1'
    results[2][:value].should eq '+1'
    results[3][:value].should eq '2.5'
  end

  it 'should parse period of bet' do
    results[0][:period].should eq 'Full_Match'
    results[4][:period].should eq '1st_Half'
    results[5][:period].should eq '2nd_Half'
  end

  it 'should parse event home' do

  end
end
